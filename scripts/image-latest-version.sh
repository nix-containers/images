#!/usr/bin/env bash
# image-latest-version.sh <image> [--json]
# Resolves the current pinned version of an image and the latest upstream
# STABLE release, from its images/<image>/default.nix. Repeatable, read-only.
#
# Detection order for the source repo:
#   fetchFromGitHub { owner=…; repo=…; }  -> GitHub releases/tags
#   fetchgit/url github.com/OWNER/REPO     -> GitHub
#   gitlab.com/OWNER/REPO                  -> GitLab tags
set -euo pipefail
img="${1:?usage: image-latest-version.sh <image> [--json]}"
def="images/$img/default.nix"
[ -f "$def" ] || { echo "no def: $def" >&2; exit 2; }

cur=$(grep -oE 'version = "[0-9][0-9A-Za-z.+-]*"' "$def" | head -1 | sed -E 's/version = "([^"]+)"/\1/')

# owner/repo from fetchFromGitHub or any github.com/OWNER/REPO
owner=$(grep -oE 'owner = "[^"]+"' "$def" | head -1 | sed -E 's/owner = "([^"]+)"/\1/')
repo=$(grep -oE 'repo = "[^"]+"' "$def" | head -1 | sed -E 's/repo = "([^"]+)"/\1/')
host="github"
if [ -z "$owner" ] || [ -z "$repo" ]; then
  slug=$(grep -oE 'github\.com/[A-Za-z0-9._-]+/[A-Za-z0-9._-]+' "$def" | head -1 | sed 's#github.com/##;s/\.git$//')
  if [ -n "$slug" ]; then owner="${slug%%/*}"; repo="${slug##*/}";
  else
    slug=$(grep -oE 'gitlab\.com/[A-Za-z0-9._/-]+' "$def" | head -1 | sed 's#gitlab.com/##')
    [ -n "$slug" ] && { host="gitlab"; owner="${slug%%/*}"; repo="${slug##*/}"; }
  fi
fi

# latest STABLE tag: prefer releases/latest, fall back to tags (semver, no rc/beta/alpha)
latest=""
if [ "$host" = "github" ] && [ -n "$owner" ] && [ -n "$repo" ]; then
  latest=$(gh api "repos/$owner/$repo/releases/latest" --jq '.tag_name' 2>/dev/null || true)
  if [ -z "$latest" ]; then
    latest=$(gh api "repos/$owner/$repo/tags?per_page=100" --jq '.[].name' 2>/dev/null \
      | grep -E '^v?[0-9]+\.[0-9]+(\.[0-9]+)?$' | sed 's/^v//' \
      | sort -t. -k1,1n -k2,2n -k3,3n | tail -1 || true)
  fi
elif [ "$host" = "gitlab" ]; then
  latest=$(curl -s "https://gitlab.com/api/v4/projects/$(printf '%s/%s' "$owner" "$repo" | sed 's#/#%2F#')/repository/tags?order_by=version&sort=desc&per_page=50" 2>/dev/null \
    | python3 -c "import json,sys,re;[print(t['name']) for t in json.load(sys.stdin) if re.match(r'^v?[0-9]+\.[0-9]+\.[0-9]+(-ee)?$',t['name']) and 'rc' not in t['name']]" 2>/dev/null | head -1 || true)
fi
latest="${latest#v}"
# strip repo-name prefixes like "cert-exporter-3.15.0" -> "3.15.0"
latest="$(printf '%s' "$latest" | sed -E 's/^.*[-_]([0-9]+\.[0-9]+(\.[0-9]+)?)$/\1/')"

if [ "${2:-}" = "--json" ]; then
  printf '{"image":"%s","host":"%s","repo":"%s/%s","current":"%s","latest":"%s","behind":%s}\n' \
    "$img" "$host" "$owner" "$repo" "$cur" "$latest" \
    "$([ -n "$latest" ] && [ "$cur" != "$latest" ] && echo true || echo false)"
else
  printf '%-32s %s/%s  current=%s  latest=%s  %s\n' "$img" "$owner" "$repo" "$cur" "${latest:-?}" \
    "$([ -n "$latest" ] && [ "$cur" != "$latest" ] && echo '<< BEHIND' || echo 'ok')"
fi
