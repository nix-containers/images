#!/usr/bin/env bash
#
# local-website-fetch-tags.sh — populate website/tags-data/ from the
# GitHub packages API for every image that has a trivy report already
# in website/scan-data/. Then enriches each entry with the compressed
# manifest size (website/enrich-tags-with-size.py).
#
# Mirrors deploy-website.yml's "Fetch curated tag list per scanned image"
# + "Enrich tags-data with compressed manifest sizes" steps.
#
# Usage:
#   scripts/local-website-fetch-tags.sh              # fetch + enrich
#   scripts/local-website-fetch-tags.sh --no-enrich  # tags only, skip sizes
#   scripts/local-website-fetch-tags.sh --parallel 4 # tune xargs -P (default 8)

set -euo pipefail

SCAN_DIR="website/scan-data"
DEST="website/tags-data"
ENRICH=1
PARALLEL=8

while [ $# -gt 0 ]; do
  case "$1" in
    --no-enrich) ENRICH=0; shift ;;
    --parallel) PARALLEL="$2"; shift 2 ;;
    -h|--help) sed -n '1,20p' "$0"; exit 0 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

if [ ! -d "$SCAN_DIR" ]; then
  echo "$SCAN_DIR missing — run local-website-fetch-scan.sh first" >&2
  exit 1
fi

mkdir -p "$DEST"

IMG_LIST="$(mktemp)"
trap 'rm -f "$IMG_LIST"' EXIT

find "$SCAN_DIR" -maxdepth 1 -name '*-trivy.json' -printf '%f\n' \
  | sed -E 's/^ghcr\.io_nix-containers_images_([^_]+(_[^_]+)*)_latest-trivy\.json$/\1/' \
  | sort -u > "$IMG_LIST"

COUNT=$(wc -l < "$IMG_LIST")
echo "fetching tags for $COUNT images (parallelism=$PARALLEL)..."

MISSES_FILE="$(mktemp)"
: > "$MISSES_FILE"
export MISSES_FILE

fetch_one() {
  local img="$1"
  local encoded="images%2F${img}"
  local tmp="website/tags-data/${img}.json.tmp"
  local attempt
  for attempt in 1 2 3; do
    if gh api --paginate \
          "/orgs/nix-containers/packages/container/${encoded}/versions" \
          2>/dev/null \
        | jq -s '
            [ .[][]
              | . as $v
              | ($v.metadata.container.tags // [])[]
              | { tag: ., digest: $v.name, pushed_at: $v.updated_at }
            ]
            | map(select(.tag | test("^[0-9a-f]{40}$") | not))
            | sort_by(.pushed_at) | reverse
          ' > "$tmp" 2>/dev/null \
        && [ -s "$tmp" ] \
        && [ "$(jq 'length' < "$tmp" 2>/dev/null || echo 0)" -gt 0 ]; then
      mv "$tmp" "website/tags-data/${img}.json"
      return
    fi
    rm -f "$tmp"
    [ "$attempt" -lt 3 ] && sleep $((attempt * attempt))
  done
  printf '%s\n' "$img" >> "$MISSES_FILE"
}
export -f fetch_one

tr '\n' '\0' < "$IMG_LIST" \
  | xargs -0 -n 1 -P "$PARALLEL" -I {} bash -c 'fetch_one "$@"' _ {}

WROTE=$(find "$DEST" -maxdepth 1 -name '*.json' | wc -l)
MISSES=$(wc -l < "$MISSES_FILE")
echo "wrote tags-data for $WROTE images; missed $MISSES"
if [ "$MISSES" -gt 0 ]; then
  echo "missed images (post-retry):"
  sed 's/^/  - /' "$MISSES_FILE"
fi
rm -f "$MISSES_FILE"

if [ "$ENRICH" -eq 1 ] && [ "$WROTE" -gt 0 ]; then
  echo "enriching tags-data with compressed manifest sizes..."
  python3 website/enrich-tags-with-size.py "$DEST"
fi

echo "done — $DEST populated"
