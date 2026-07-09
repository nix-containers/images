#!/usr/bin/env bash
#
# local-website-serve.sh — serve ./website-build/ for local preview.
#
# The site expects to be served under PAGES_BASE_PATH (defaults to "/"
# for local builds). If you built with PAGES_BASE_PATH=/images/ to
# mirror prod, this script rewrites the base path back to "/" in memory
# via a URL prefix rewrite, so links work when served at http://localhost:PORT/.
#
# Usage:
#   scripts/local-website-serve.sh                # port 8000
#   scripts/local-website-serve.sh --port 9000
#   scripts/local-website-serve.sh --open         # also xdg-open the URL

set -euo pipefail

PORT=8000
OPEN=0
while [ $# -gt 0 ]; do
  case "$1" in
    --port) PORT="$2"; shift 2 ;;
    --open) OPEN=1; shift ;;
    -h|--help) sed -n '1,15p' "$0"; exit 0 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

if [ ! -d website-build ]; then
  echo "website-build/ missing — run local-website-build.sh first" >&2
  exit 1
fi

URL="http://localhost:$PORT/"
echo "serving website-build/ at $URL  (Ctrl+C to stop)"
[ "$OPEN" -eq 1 ] && command -v xdg-open >/dev/null && (sleep 0.4 && xdg-open "$URL" &) || true
cd website-build
exec python3 -m http.server "$PORT"
