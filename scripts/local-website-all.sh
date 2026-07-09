#!/usr/bin/env bash
#
# local-website-all.sh — end-to-end driver: fetch scan → fetch tags →
# build → (optionally serve, or publish).
#
# Mirrors the whole deploy-website.yml pipeline in one shot. Each phase
# is a separate script so you can re-run a slice without redoing the
# whole thing.
#
# Usage:
#   scripts/local-website-all.sh                          # fetch + build only
#   scripts/local-website-all.sh --serve                  # + local preview
#   scripts/local-website-all.sh --publish workflow       # + dispatch prod deploy
#   scripts/local-website-all.sh --publish branch         # + push to gh-pages
#   scripts/local-website-all.sh --skip-scan --skip-tags  # rebuild only

set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

SKIP_SCAN=0
SKIP_TAGS=0
SERVE=0
PUBLISH=""

while [ $# -gt 0 ]; do
  case "$1" in
    --skip-scan) SKIP_SCAN=1; shift ;;
    --skip-tags) SKIP_TAGS=1; shift ;;
    --serve) SERVE=1; shift ;;
    --publish) PUBLISH="$2"; shift 2 ;;
    -h|--help) sed -n '1,20p' "$0"; exit 0 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

phase() { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }

if [ "$SKIP_SCAN" -eq 0 ]; then
  phase "1/4  fetch scan-data"
  scripts/local-website-fetch-scan.sh
fi

if [ "$SKIP_TAGS" -eq 0 ]; then
  phase "2/4  fetch tags-data + enrich sizes"
  scripts/local-website-fetch-tags.sh
fi

phase "3/4  build static site"
scripts/local-website-build.sh

case "$PUBLISH" in
  "") ;;
  workflow) phase "4/4  publish via workflow_dispatch"; scripts/local-website-publish.sh --via-workflow ;;
  branch)   phase "4/4  publish via gh-pages branch";  scripts/local-website-publish.sh --via-branch ;;
  *) echo "unknown --publish mode: $PUBLISH (workflow|branch)" >&2; exit 2 ;;
esac

if [ "$SERVE" -eq 1 ]; then
  phase "serve at http://localhost:8000/"
  exec scripts/local-website-serve.sh
fi

echo ""
echo "done. next steps:"
echo "  preview:  scripts/local-website-serve.sh"
echo "  publish:  scripts/local-website-publish.sh --via-workflow"
echo "  publish:  scripts/local-website-publish.sh --via-branch   # if Pages source = gh-pages"
