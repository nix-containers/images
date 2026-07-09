#!/usr/bin/env bash
#
# local-website-fetch-scan.sh — download the latest non-empty
# `security-scan-results` artifact from GHA into website/scan-data/.
#
# Mirrors deploy-website.yml's "Download latest non-empty security scan
# results" + "Stage scan-data" steps, so a subsequent `nix build .#website`
# sees the same input CI would.
#
# Auth: uses your existing `gh auth login` credentials.
#
# Usage:
#   scripts/local-website-fetch-scan.sh                 # walk recent runs
#   scripts/local-website-fetch-scan.sh --run <run-id>  # a specific run
#   scripts/local-website-fetch-scan.sh --clear         # wipe local scan-data

set -euo pipefail

REPO="nix-containers/images"
DEST="website/scan-data"

RUN_ID=""
CLEAR=0
while [ $# -gt 0 ]; do
  case "$1" in
    --run) RUN_ID="$2"; shift 2 ;;
    --clear) CLEAR=1; shift ;;
    -h|--help) sed -n '1,25p' "$0"; exit 0 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

if [ "$CLEAR" -eq 1 ]; then
  rm -rf "$DEST"
  echo "cleared $DEST"
  exit 0
fi

mkdir -p "$DEST"

pick_run() {
  if [ -n "$RUN_ID" ]; then
    echo "$RUN_ID"
    return
  fi
  gh run list --repo "$REPO" \
    --workflow=security-scan.yml --branch=main --status=completed \
    --limit=10 --json databaseId --jq '.[].databaseId'
}

RUNS=$(pick_run)
if [ -z "$RUNS" ]; then
  echo "no completed security-scan.yml runs found on main" >&2
  exit 1
fi

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

for id in $RUNS; do
  echo "trying run $id..."
  rm -rf "$TMPDIR"/download
  mkdir -p "$TMPDIR"/download
  if ! gh run download "$id" --repo "$REPO" \
        -n security-scan-results -D "$TMPDIR"/download 2>&1; then
    echo "  download failed; skipping"
    continue
  fi
  COUNT=$(find "$TMPDIR"/download -maxdepth 1 -name '*-trivy.json' 2>/dev/null | wc -l)
  if [ "$COUNT" -gt 0 ]; then
    echo "using run $id ($COUNT scanned images)"
    rm -rf "$DEST"
    mkdir -p "$DEST"
    cp -a "$TMPDIR"/download/. "$DEST"/
    echo "$id" > "$DEST/.source-run-id"
    date -u +'%Y-%m-%dT%H:%M:%SZ' > "$DEST/.fetched-at"
    exit 0
  fi
  echo "  empty artifact; skipping"
done

echo "no non-empty artifact found in recent runs" >&2
exit 1
