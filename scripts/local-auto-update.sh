#!/usr/bin/env bash
#
# local-auto-update.sh — local counterpart to .github/workflows/auto-update.yml.
#
# Two-part dependency automation, matching the CI workflow:
#   (a) `nix flake update` — bumps flake.lock (nixpkgs + nix2container).
#   (b) per-package `nix-update` — walks pkgs/_update.nix's attr set (the
#       custom overlay packages), running nix-update --version=stable
#       --src-only against each, tolerating per-package failures.
#
# Notes:
#   - GITHUB_TOKEN comes from `gh auth token` for nix-update's release
#     lookups (short-lived; refresh per invocation).
#   - Excludes font-/ttf- aliases (they just point at nixpkgs).
#   - Writes updated.md / failed.md / skipped.md summaries in the repo root.
#
# Usage:
#   scripts/local-auto-update.sh                     # flake + all packages
#   scripts/local-auto-update.sh --flake-only        # just nix flake update
#   scripts/local-auto-update.sh --packages a,b,c    # CSV subset (intersected
#                                                     # with the known attr set)

set -uo pipefail

cd "$(git rev-parse --show-toplevel)"

FLAKE_ONLY=0
PACKAGES_CSV=""
while [ $# -gt 0 ]; do
  case "$1" in
    --flake-only) FLAKE_ONLY=1; shift ;;
    --packages) PACKAGES_CSV="$2"; shift 2 ;;
    -h|--help) sed -n '1,20p' "$0"; exit 0 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

# GITHUB_TOKEN for nix-update's release/atom API lookups.
if command -v gh >/dev/null 2>&1; then
  GH_TOKEN=$(gh auth token 2>/dev/null || true)
  [ -n "${GH_TOKEN:-}" ] && export GITHUB_TOKEN="$GH_TOKEN"
fi

echo "==> nix flake update (nixpkgs + nix2container)…"
if nix flake update 2>&1 | tail -10; then
  echo "==> flake.lock updated"
else
  echo "!!  nix flake update failed (continuing with package bumps)"
fi

if [ "$FLAKE_ONLY" -eq 1 ]; then
  echo "==> --flake-only; skipping per-package bumps"
  exit 0
fi

echo "==> resolving overlay package attrs (pkgs/_update.nix, minus font-/ttf- aliases)…"
ALL=$(nix --extra-experimental-features "nix-command flakes" eval --impure --json --expr '
  let f = import ./pkgs/_update.nix {}; in
  builtins.filter (n: builtins.match "(font-|ttf-).*" n == null) (builtins.attrNames f)
')

if [ -n "$PACKAGES_CSV" ]; then
  PKGS=$(printf '%s' "$ALL" | jq -c --arg csv "$PACKAGES_CSV" '
    ($csv | split(",") | map(gsub("^\\s+|\\s+$"; "")) | map(select(length > 0))) as $want
    | map(select(. as $n | $want | index($n)))
  ')
else
  PKGS="$ALL"
fi
COUNT=$(printf '%s' "$PKGS" | jq 'length')
echo "==> $COUNT packages to check"

NIX_UPDATE=(nix --extra-experimental-features "nix-command flakes" run github:Mic92/nix-update --)

: > updated.md
: > failed.md
: > skipped.md

TOTAL=0; UPD=0; FAIL=0; SKIP=0
for ATTR in $(printf '%s' "$PKGS" | jq -r '.[]'); do
  TOTAL=$((TOTAL + 1))
  BEFORE=$(git hash-object "pkgs/$ATTR/default.nix" 2>/dev/null || echo "")
  echo "-- [$TOTAL/$COUNT] nix-update $ATTR --"
  # --version=stable: only follow stable upstream releases.
  # --src-only: just bump src/version/hash; don't try to regenerate vendored
  #             cargo/go/npm deps (mostly prebuilt-binary derivations).
  if "${NIX_UPDATE[@]}" --version=stable --src-only "$ATTR" > "/tmp/local-nix-update-$ATTR.log" 2>&1; then
    AFTER=$(git hash-object "pkgs/$ATTR/default.nix" 2>/dev/null || echo "")
    if [ "$BEFORE" != "$AFTER" ]; then
      echo "- $ATTR" >> updated.md
      UPD=$((UPD + 1))
    else
      echo "- $ATTR (already at latest stable)" >> skipped.md
      SKIP=$((SKIP + 1))
    fi
  else
    tail1=$(tail -1 "/tmp/local-nix-update-$ATTR.log" 2>/dev/null || true)
    echo "- $ATTR: ${tail1:-unknown error}" >> failed.md
    FAIL=$((FAIL + 1))
  fi
done

echo ""
echo "==> done. updated=$UPD  failed=$FAIL  skipped=$SKIP  total=$TOTAL"
echo "-- updated.md --"; sed 's/^/  /' updated.md || true
echo "-- failed.md --";  sed 's/^/  /' failed.md  || true
echo ""
echo "next steps:"
echo "  git diff --stat flake.lock pkgs/"
echo "  git commit -am 'deps: nix flake update + per-package bumps'"
