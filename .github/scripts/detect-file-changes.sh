#!/usr/bin/env bash
# Classify changed file paths into per-image and shared-rebuild-all buckets.
# Reads paths from stdin (one per line). Reads FULL_MATRIX env var (JSON of
# discovered images, shape: {"include":[{"name","path"},...]}).
# Writes classification JSON to stdout.
set -euo pipefail

: "${FULL_MATRIX:?FULL_MATRIX env var required}"

# Read all changed paths from stdin into a JSON array.
CHANGED_PATHS=$(jq -Rs 'split("\n") | map(select(length > 0))')

# Extract per-image names from paths matching images/<name>/...
PER_IMAGE_NAMES=$(printf '%s' "$CHANGED_PATHS" | jq -c '
  [.[] | capture("^images/(?<n>[^/]+)/.+")? | .n] | unique
')

# Filter against the discovered matrix: drop names that no longer exist.
CHANGED_INCLUDE=$(jq -cn \
  --argjson names "$PER_IMAGE_NAMES" \
  --argjson full "$FULL_MATRIX" '
  [$full.include[] | select(.name as $n | $names | index($n))]
')

CHANGES_DETECTED=$(printf '%s' "$CHANGED_INCLUDE" | jq -r 'if length > 0 then "true" else "false" end')

jq -cn \
  --arg detected "$CHANGES_DETECTED" \
  --argjson inc "$CHANGED_INCLUDE" \
  '{"changes-detected": $detected, "changed-images": {"include": $inc}, "rebuild-all": "false"}'
