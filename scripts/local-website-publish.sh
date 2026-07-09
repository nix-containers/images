#!/usr/bin/env bash
#
# local-website-publish.sh — publish ./website-build/ to production
# GitHub Pages. Two publish modes:
#
#   --via-workflow   (default) dispatch deploy-website.yml on GHA; the
#                    workflow rebuilds the site with the current main
#                    contents. Fast, but relies on CI runners.
#
#   --via-branch     force-push ./website-build/ to the `gh-pages`
#                    branch of the repo. Requires the Pages source to
#                    be switched to "Deploy from a branch → gh-pages".
#                    Fully local build path — no CI needed for the
#                    publish itself, and no GHA-only credentials.
#
# The --via-branch flow works only if you've flipped Settings → Pages
# → Source → Deploy from a branch → gh-pages / (root). Actions-source
# Pages deploys need OIDC tokens that only GHA workers can mint.
#
# Usage:
#   scripts/local-website-publish.sh --via-workflow
#   scripts/local-website-publish.sh --via-branch [--remote upstream]

set -euo pipefail

MODE="via-workflow"
REMOTE="upstream"
REPO="nix-containers/images"

while [ $# -gt 0 ]; do
  case "$1" in
    --via-workflow) MODE="via-workflow"; shift ;;
    --via-branch) MODE="via-branch"; shift ;;
    --remote) REMOTE="$2"; shift 2 ;;
    --repo) REPO="$2"; shift 2 ;;
    -h|--help) sed -n '1,25p' "$0"; exit 0 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

case "$MODE" in
  via-workflow)
    echo "dispatching deploy-website.yml on $REPO..."
    gh workflow run "Deploy Website to GitHub Pages" --repo "$REPO" \
      -f runner=ubuntu-latest
    sleep 3
    gh run list --repo "$REPO" --workflow=deploy-website.yml \
      --limit 1 --json databaseId,status,event,createdAt \
      --jq '.[] | "run \(.databaseId) [\(.event)] \(.status) at \(.createdAt)"'
    echo "watch: gh run watch --repo $REPO"
    ;;

  via-branch)
    if [ ! -d website-build ]; then
      echo "website-build/ missing — run local-website-build.sh first" >&2
      exit 1
    fi
    if ! git remote get-url "$REMOTE" >/dev/null 2>&1; then
      echo "remote '$REMOTE' not configured; use --remote <name>" >&2
      exit 1
    fi

    # Ensure the site was built with the right base-path.
    BASE_PATH="$(grep -m1 -oE 'href="[^"]*/static/[^"]*"' website-build/index.html \
      | sed -E 's|.*href="([^/]*(/[^/]+)*)/static/.*|\1|' || true)"
    if [ "$BASE_PATH" != "/${REPO##*/}" ] && [ "$BASE_PATH" != "" ]; then
      echo "warning: built with PAGES_BASE_PATH='$BASE_PATH/'"
      echo "         for gh-pages branch deploys use PAGES_BASE_PATH=/${REPO##*/}/"
    fi

    TMP="$(mktemp -d)"
    trap 'rm -rf "$TMP"' EXIT

    echo "publishing ./website-build/ to $REMOTE gh-pages..."
    cp -a website-build/. "$TMP"/
    ( cd "$TMP" && \
      git init -q && \
      git checkout -q --orphan gh-pages && \
      touch .nojekyll && \
      git add -A && \
      git -c user.email=deploy@nix-containers.local \
          -c user.name=deploy-bot commit -q -m "site: $(date -u +%Y-%m-%dT%H:%M:%SZ)" && \
      git push -f "$(cd - >/dev/null; git remote get-url "$REMOTE")" gh-pages )
    echo "pushed to $REMOTE gh-pages — Pages will pick it up shortly"
    ;;
esac
