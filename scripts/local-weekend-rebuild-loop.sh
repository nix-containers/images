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
rank_images() {
  local minc="$1"
  python3 - "$minc" <<'PY'
import json, os, glob, re, sys
minc = int(sys.argv[1])
scored = []
for p in glob.glob('website/scan-data/*-trivy.json'):
    m = re.match(r'.*ghcr\.io_nix-containers_images_(.+)_latest-trivy\.json$', p)
    if not m: continue
    img = m.group(1)
    if not os.path.isdir(f'images/{img}'): continue
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

stamp "==== weekend rebuild loop starting: batch=$BATCH sleep=${SLEEP}s min-cves=$MIN_CVES ===="
batch_num=0
while true; do
  batch_num=$((batch_num + 1))
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

  # Reset state for these images so build-scan-push actually re-runs them.
  while IFS= read -r img; do
    rm -f "$STATE_DIR/${img}.state"
  done < /tmp/rebuild-batch.txt

  if scripts/local-build-scan-push.sh /tmp/rebuild-batch.txt >/tmp/rebuild-bsp.log 2>&1; then
    ok=$(grep -c '^ok$' "$STATE_DIR"/*.state 2>/dev/null || echo 0)
    stamp "  bsp: run finished; final state files show $ok ok"
  else
    stamp "  bsp: exited non-zero (see /tmp/rebuild-bsp.log)"
  fi

  # After a bsp run, scan-data reflects the fresh CVE count — next iteration's
  # ranking will drop this batch off the top (or rank them lower if some CVEs
  # persist as un-fixable-yet).

  stamp "sleeping ${SLEEP}s before next batch"
  sleep "$SLEEP"
done
