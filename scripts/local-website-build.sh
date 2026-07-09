#!/usr/bin/env bash
#
# local-website-build.sh — build the static site the same way
# deploy-website.yml does, but locally. Requires website/scan-data/
# and website/tags-data/ to be populated first (see local-website-fetch-*.sh).
#
# Output: ./website-build/  (identical layout to what actions/upload-pages-artifact
# would upload).
#
# Env overrides (all optional):
#   PAGES_BASE_PATH  — default "/" for pure-local preview.
#                      Set to "/images/" to mirror GH Pages project-site paths.
#   LAST_BUILD_AT    — RFC3339 timestamp for the "last built" freshness dot.
#                      Auto-fetched from the last successful build-containers.yml
#                      run when GH_TOKEN or gh auth is available.
#
# Usage:
#   scripts/local-website-build.sh
#   PAGES_BASE_PATH=/images/ scripts/local-website-build.sh   # matches prod URL

set -euo pipefail

if [ ! -d website/scan-data ]; then
  echo "website/scan-data/ missing — run local-website-fetch-scan.sh first" >&2
  exit 1
fi

if [ ! -d website/tags-data ]; then
  echo "note: website/tags-data/ missing — Tags tab will render empty" >&2
  echo "      (run local-website-fetch-tags.sh to populate)" >&2
fi

: "${PAGES_BASE_PATH:=/}"
export PAGES_BASE_PATH

# Auto-detect LAST_BUILD_AT unless caller supplied one.
if [ -z "${LAST_BUILD_AT:-}" ]; then
  if command -v gh >/dev/null 2>&1; then
    LAST_BUILD_AT=$(gh run list --repo nix-containers/images \
      --workflow=build-containers.yml --branch=main --status=success \
      --limit=1 --json createdAt --jq '.[0].createdAt // ""' 2>/dev/null || echo "")
  fi
  LAST_BUILD_AT="${LAST_BUILD_AT:-}"
fi
export LAST_BUILD_AT

# SCAN_DATA_PATH must be a path reachable inside the Nix sandbox.
# The workflow bind-mounts the source tree via `git add -f`; for local
# builds we stage the same way so the flake sees the files.
if ! git ls-files --error-unmatch website/scan-data >/dev/null 2>&1; then
  git add -f website/scan-data/
fi
if [ -d website/tags-data ] && ! git ls-files --error-unmatch website/tags-data >/dev/null 2>&1; then
  git add -f website/tags-data/ 2>/dev/null || true
fi

# Point SCAN_DATA_PATH at the tree-relative dir so generate-site.nix can read it.
export SCAN_DATA_PATH="$PWD/website/scan-data"

echo "building website:"
echo "  PAGES_BASE_PATH=$PAGES_BASE_PATH"
echo "  SCAN_DATA_PATH=$SCAN_DATA_PATH ($(find website/scan-data -maxdepth 1 -name '*-trivy.json' | wc -l) trivy files)"
echo "  LAST_BUILD_AT=${LAST_BUILD_AT:-<none>}"
[ -d website/tags-data ] && echo "  tags-data=$(find website/tags-data -maxdepth 1 -name '*.json' | wc -l) files"

nix build .#website --impure --print-build-logs

rm -rf ./website-build
mkdir -p ./website-build
cp -r ./result/. ./website-build/
chmod -R u+w ./website-build

echo ""
echo "built: ./website-build/  ($(du -sh ./website-build | cut -f1))"
echo "preview: scripts/local-website-serve.sh"
