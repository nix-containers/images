#!/usr/bin/env bash
#
# local-auto-update-inline.sh — local counterpart to
# .github/workflows/auto-update-inline.yml.
#
# Runs nvchecker against nvchecker.toml + the GITHUB_TOKEN from `gh auth
# token`, greps nvcmp output for outdated entries, and dispatches each to
# scripts/bump-inline-image.sh (same driver the CI workflow uses). Ends
# by advancing old_versions.json for every entry whose images all bumped
# cleanly — matching the CI baseline-advance behavior — so a follow-up
# run doesn't try to bump the same set again.
#
# Notes:
#   - Bumps ONLY inline-fetch images (fetchurl / fetchFromGitHub /
#     pullImage), because that's what bump-inline-image.sh handles.
#     nixpkgs-sourced images (drv = pkgs.<attr>) are the domain of the
#     other pipeline (auto-update.yml → nix-update via flake.lock).
#   - Leaves scan-data + tags-data alone (no side-effect commits).
#   - Writes bumped.md / failed.md summaries in the repo root.
#
# Usage:
#   scripts/local-auto-update-inline.sh                  # default: 50 image cap
#   scripts/local-auto-update-inline.sh --limit 200      # bump up to 200
#   scripts/local-auto-update-inline.sh --dry-run        # nvcmp only, no bumps
#   scripts/local-auto-update-inline.sh --entries a,b,c  # only these nvchecker entries

set -uo pipefail

cd "$(git rev-parse --show-toplevel)"

LIMIT=50
DRY=0
FILTER_ENTRIES=""
while [ $# -gt 0 ]; do
  case "$1" in
    --limit) LIMIT="$2"; shift 2 ;;
    --dry-run) DRY=1; shift ;;
    --entries) FILTER_ENTRIES="$2"; shift 2 ;;
    -h|--help) sed -n '1,30p' "$0"; exit 0 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

# GITHUB_TOKEN from gh CLI. Short-lived; the workflow gets a fresh one
# per run, so we refresh here too.
if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI required — install nixpkgs#gh + \`gh auth login\`" >&2
  exit 2
fi
GH_TOKEN=$(gh auth token 2>/dev/null || true)
if [ -z "${GH_TOKEN:-}" ]; then
  echo "gh auth token empty — run \`gh auth login\` first" >&2
  exit 2
fi
export NIXPKGS_ALLOW_INSECURE=1

KEYFILE=$(mktemp)
printf '[keys]\ngithub = "%s"\n' "${GH_TOKEN}" > "$KEYFILE"
trap 'rm -f "$KEYFILE"' EXIT

echo "==> nvchecker (querying upstream release feeds)…"
nix shell nixpkgs#nvchecker -c nvchecker -c nvchecker.toml --keyfile "$KEYFILE" || true

echo "==> nvcmp (diffing new -> old)…"
OUTDATED=$(mktemp)
nix shell nixpkgs#nvchecker -c nvcmp -c nvchecker.toml 2>/dev/null | grep -E '\->' > "$OUTDATED" || true
OUTDATED_COUNT=$(wc -l < "$OUTDATED" | tr -d ' ')
echo "==> outdated entries: $OUTDATED_COUNT"

if [ "$DRY" -eq 1 ]; then
  echo "== dry-run — outdated set follows =="
  cat "$OUTDATED"
  rm -f "$OUTDATED"
  exit 0
fi

# Filter to a specific set of entries when requested.
if [ -n "$FILTER_ENTRIES" ]; then
  FILTERED=$(mktemp)
  # Substr match on the first column against the CSV.
  python3 - "$OUTDATED" "$FILTER_ENTRIES" > "$FILTERED" <<'PY'
import sys
outdated_path, csv = sys.argv[1], sys.argv[2]
wanted = {s.strip() for s in csv.split(",") if s.strip()}
for line in open(outdated_path):
    parts = line.strip().split()
    if parts and parts[0] in wanted:
        print(line.rstrip("\n"))
PY
  mv "$FILTERED" "$OUTDATED"
  echo "==> filter narrowed to $(wc -l < "$OUTDATED" | tr -d ' ') entries"
fi

count=0
: > bumped.md
: > failed.md

# Path-augment for pullImage bumps so scripts/bump-inline-image.sh finds
# skopeo without needing the user to pre-shell it in.
export PATH="$(nix eval --raw nixpkgs#skopeo)/bin:$PATH"

while read -r entry old arrow new; do
  [ -z "${entry:-}" ] && continue
  [ "$count" -ge "$LIMIT" ] && { echo "==> hit --limit=$LIMIT; stopping"; break; }

  imgs=$(jq -r --arg e "$entry" '.[$e][]? // empty' nvchecker-images.json)
  if [ -z "$imgs" ]; then
    # nvchecker knew about the entry but nvchecker-images.json doesn't
    # map it — nothing this driver can bump.
    continue
  fi

  entry_ok=1
  for img in $imgs; do
    [ "$count" -ge "$LIMIT" ] && { entry_ok=0; break; }
    log="/tmp/local-bump-${img}.log"
    printf '  -> %-40s %-15s -> %s\n' "$img" "$old" "$new"
    # Hard-timeout each bump at 15 min. A stuck hash-repair loop (e.g. a Java
    # image with a huge maven fetch) can otherwise eat the whole overnight run;
    # timeout 124 (from coreutils) means the bumper was killed after 15 min.
    if timeout --kill-after=30s 15m bash scripts/bump-inline-image.sh "$img" "$new" > "$log" 2>&1; then
      echo "- \`$img\` ${old} → ${new}" >> bumped.md
      count=$((count+1))
    else
      rc=$?
      if [ "$rc" = "124" ] || [ "$rc" = "137" ]; then
        echo "- \`$img\` (${entry} → ${new}): timed out after 15m" >> failed.md
      else
        echo "- \`$img\` (${entry} → ${new}): $(tail -1 "$log")" >> failed.md
      fi
      entry_ok=0
    fi

    # Reclaim /nix/store when disk gets low so a long run of image
    # builds doesn't hit "no space left on device" (same guard the CI
    # workflow has).
    if [ "$(df --output=avail / | tail -1)" -lt 4194304 ]; then
      echo "     (disk low — running nix-collect-garbage)"
      nix-collect-garbage >/dev/null 2>&1 || true
    fi
  done

  # Advance the baseline only when every image for this entry bumped
  # cleanly, so partial failures are retried next run.
  if [ "$entry_ok" = "1" ]; then
    tmp=$(mktemp); jq --arg e "$entry" --arg v "$new" '.[$e]=$v' old_versions.json > "$tmp" && mv "$tmp" old_versions.json
  fi
done < "$OUTDATED"

rm -f "$OUTDATED"

BUMPED=$(wc -l < bumped.md | tr -d ' ')
FAILED=$(wc -l < failed.md | tr -d ' ')
echo ""
echo "==> bumped: $BUMPED  failed: $FAILED"
[ -s bumped.md ] && { echo "-- bumped.md --"; cat bumped.md; }
[ -s failed.md ] && { echo "-- failed.md --"; cat failed.md; }

# When routing builds to a secondary store (IMAGE_NIX_STORE), reap versions
# superseded by this batch's bumps: each bumped image's gc root now points at
# the NEW version, so the old one is unreachable and collectable. Shared deps
# still referenced by other image roots survive.
if [ -n "${IMAGE_NIX_STORE:-}" ] && [ "$BUMPED" -gt 0 ]; then
  echo ""
  echo "==> gc secondary store ${IMAGE_NIX_STORE} (reap superseded versions)…"
  nix store gc --store "${IMAGE_NIX_STORE}" 2>&1 | tail -2 || true
fi
echo ""
echo "next steps:"
echo "  review + commit: git diff images/ old_versions.json"
echo "  or open a PR:    git checkout -b auto-update/inline-images && git add … && git commit"
