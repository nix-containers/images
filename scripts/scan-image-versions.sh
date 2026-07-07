#!/usr/bin/env bash
# scan-image-versions.sh [imglist] — report which image defs are behind upstream.
set -uo pipefail
list="${1:-}"
imgs=$( [ -n "$list" ] && cat "$list" || ls images | while read i; do grep -qlE 'fetchFromGitHub|github.com|gitlab.com' "images/$i/default.nix" 2>/dev/null && echo "$i"; done )
for img in $imgs; do timeout 20 bash scripts/image-latest-version.sh "$img" 2>/dev/null | grep -F 'BEHIND' || true; done
