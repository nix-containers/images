#!/usr/bin/env bash
#
# local-weekend-rebuild-loop.sh — hands-off rebuild sweep for the
# "at-latest but bundled deps have CVEs" bucket.
#
# The overnight orchestrator (local-overnight-orchestrator.sh) handles the
# **version bump** side — when nvchecker or nixpkgs sees a newer upstream,
# the file gets bumped and the next build picks up the new source. That
# doesn't help images already at the tracker-latest whose CVEs live in a
# bundled Go stdlib / Java runtime — those clear only when the whole image
# rebuilds against the current nix toolchain.
#
# This driver:
#   1. Ranks images by their current CRITICAL+HIGH count (per website's
#      scan-data), highest-first.
#   2. Picks the next batch (default 5), clears any prior local-bsp state
#      so build-scan-push actually re-runs the build.
#   3. Delegates to scripts/local-build-scan-push.sh, which does the same
#      build → push :latest → trivy/grype/syft → oras-attach dance the
#      security-scan.yml workflow does.
#   4. Reclaims /nix/store when free space drops under 15 GiB — same guard
#      the orchestrator uses so a weekend of Java builds doesn't fill the
#      disk.
#   5. Sleeps N seconds between batches. Runs until Ctrl-C / TaskStop.
#
# Usage:
#   scripts/local-weekend-rebuild-loop.sh                # 5 imgs/batch, 60s sleep
#   scripts/local-weekend-rebuild-loop.sh --batch 10
#   scripts/local-weekend-rebuild-loop.sh --sleep 300
#   scripts/local-weekend-rebuild-loop.sh --min-cves 20  # skip images below this

set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

BATCH=5
SLEEP=60
MIN_CVES=1
while [ $# -gt 0 ]; do
  case "$1" in
    --batch)     BATCH="$2"; shift 2 ;;
    --sleep)     SLEEP="$2"; shift 2 ;;
    --min-cves)  MIN_CVES="$2"; shift 2 ;;
    -h|--help)   sed -n '1,32p' "$0"; exit 0 ;;
    *)           echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

mkdir -p state
LOG="state/rebuild-loop.log"
stamp() { echo "[$(date -u +%FT%TZ)] $*" | tee -a "$LOG"; }

reclaim_if_tight() {
  local free
  free=$(df -BG /nix | awk 'NR==2 {gsub("G","",$4); print $4}')
  if [ "$free" -lt 15 ]; then
    stamp "/nix has ${free}G free — running nix-collect-garbage --delete-older-than 2d"
    nix-collect-garbage --delete-older-than 2d >/tmp/nix-gc-rebuild.log 2>&1 || true
  fi
}

# Rank images by CRITICAL+HIGH count; that's the ROI signal. Skip images
# without a scan (nothing to rebuild-for) and images below --min-cves.
# Also skip images that already have a state file — either they succeeded
# (ok — we'll re-add them to the queue by removing state manually) or they
# failed (fail-*) and we shouldn't spin on them every iteration.
rank_images() {
  local minc="$1"
  python3 - "$minc" <<'PY'
import json, os, glob, re, sys
minc = int(sys.argv[1])
state_dir = "audit-results/local-bsp"
scored = []
for p in glob.glob('website/scan-data/*-trivy.json'):
    m = re.match(r'.*ghcr\.io_nix-containers_images_(.+)_latest-trivy\.json$', p)
    if not m: continue
    img = m.group(1)
    if not os.path.isdir(f'images/{img}'): continue
    # Skip anything with an existing state file — either it succeeded (already
    # rebuilt fresh this session) or failed (retrying wastes compute).
    if os.path.exists(f'{state_dir}/{img}.state'): continue
    try:
        d = json.load(open(p))
    except Exception:
        continue
    c = h = 0
    for res in d.get('Results', []) or []:
        for v in res.get('Vulnerabilities', []) or []:
            sev = v.get('Severity', '')
            if sev == 'CRITICAL': c += 1
            elif sev == 'HIGH':   h += 1
    if c + h >= minc:
        scored.append((c, h, img))
# Critical first, high tiebreaker, image name deterministic.
scored.sort(key=lambda t: (-t[0], -t[1], t[2]))
for c, h, i in scored:
    print(f"{c}\t{h}\t{i}")
PY
}

# The state file we clear so build-scan-push re-runs. skip already-in-flight
# images (state file is a tiny gate; if we hit conflicts, orchestrator/bsp
# handle their own errors).
STATE_DIR="audit-results/local-bsp"

refresh_ghcr_login() {
  # `gh auth token` returns short-lived ghs_* sessions. Re-login every
  # few batches so long weekend runs don't stall in fail-push after
  # the docker credential silently expires.
  if command -v gh >/dev/null 2>&1 && command -v docker >/dev/null 2>&1; then
    gh auth token 2>/dev/null | docker login ghcr.io -u itpick --password-stdin >/dev/null 2>&1 || true
  fi
}

stamp "==== weekend rebuild loop starting: batch=$BATCH sleep=${SLEEP}s min-cves=$MIN_CVES ===="
refresh_ghcr_login
batch_num=0
while true; do
  batch_num=$((batch_num + 1))
  # Refresh docker/GHCR credentials every 20 batches (~20-40 min).
  if [ $((batch_num % 20)) -eq 1 ] && [ "$batch_num" -gt 1 ]; then
    refresh_ghcr_login
    stamp "refreshed GHCR docker login"
  fi
  reclaim_if_tight

  # Pick the next N high-CVE images that we haven't rebuilt this session.
  # State files are cleared each iteration so we always pick fresh candidates.
  tmpl=$(mktemp)
  rank_images "$MIN_CVES" | head -n "$BATCH" > "$tmpl"
  if ! [ -s "$tmpl" ]; then
    stamp "no images match --min-cves=$MIN_CVES; sleeping ${SLEEP}s"
    rm -f "$tmpl"
    sleep "$SLEEP"
    continue
  fi

  # Extract just the image column for build-scan-push
  cut -f3 "$tmpl" > /tmp/rebuild-batch.txt
  rm -f "$tmpl"

  stamp "==== batch $batch_num: rebuilding $(wc -l < /tmp/rebuild-batch.txt) images ===="
  cat /tmp/rebuild-batch.txt | sed 's/^/    /' >> "$LOG"

  # Reset state ONLY for images whose last outcome was ok — we want to force
  # a fresh rebuild+scan on those. Keep fail-build / fail-push / fail-scan /
  # fail-attach in place so bsp skips known-broken images (the state gate).
  # A fail-build image will otherwise soak up compute on every iteration.
  while IFS= read -r img; do
    st_file="$STATE_DIR/${img}.state"
    if [ -f "$st_file" ] && [ "$(cat "$st_file")" = "ok" ]; then
      rm -f "$st_file"
    fi
  done < /tmp/rebuild-batch.txt

  # Filter out images that will be skipped by bsp (still have a state file =
  # fail-*). If the whole batch is skippable, don't even invoke bsp — just
  # bump the min-cves floor for this iteration to move on to fresh candidates.
  # We can't raise min-cves at runtime here easily, so instead we bail and
  # bump the batch counter — next loop we'll pick a different (larger) set.
  actionable=$(while IFS= read -r img; do
    [ ! -f "$STATE_DIR/${img}.state" ] && echo "$img"
  done < /tmp/rebuild-batch.txt)
  if [ -z "$actionable" ]; then
    stamp "  bsp: all $BATCH images already have fail-* state; skipping this batch"
    stamp "sleeping ${SLEEP}s before next batch"
    sleep "$SLEEP"
    continue
  fi
  printf '%s\n' "$actionable" > /tmp/rebuild-batch.txt

  if scripts/local-build-scan-push.sh /tmp/rebuild-batch.txt >/tmp/rebuild-bsp.log 2>&1; then
    # `cat` avoids grep-c's per-file "file:count" format; wc -l counts total ok's.
    ok=$(cat "$STATE_DIR"/*.state 2>/dev/null | grep -c '^ok$' || echo 0)
    stamp "  bsp: run finished; ok=$ok total across all state files"
  else
    stamp "  bsp: exited non-zero (see /tmp/rebuild-bsp.log)"
  fi

  # After a bsp run, scan-data reflects the fresh CVE count — next iteration's
  # ranking will drop this batch off the top (or rank them lower if some CVEs
  # persist as un-fixable-yet).

  stamp "sleeping ${SLEEP}s before next batch"
  sleep "$SLEEP"
done
