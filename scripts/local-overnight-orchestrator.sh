#!/usr/bin/env bash
#
# local-overnight-orchestrator.sh — long-running dependency-refresh loop.
#
# One cycle:
#   1. `scripts/local-nvchecker-coverage-expand.sh`
#      Enrolls newly-added images that have a discoverable GitHub source.
#   2. `scripts/local-auto-update-inline.sh --limit N`
#      Walks nvcmp outdated entries, bumps images that use inline
#      version/hash pairs (buildGoModule, fetchurl, fetchzip, pullImage).
#   3. `scripts/local-auto-update.sh`
#      `nix flake update` + per-package `nix-update` for the nixpkgs
#      overlays under pkgs/_update.nix.
#
# Between cycles: sleep, reclaim /nix/store if it's tight, repeat.
#
# The loop keeps going until the user Ctrl-Cs or `pkill -f
# local-overnight-orchestrator`. Every cycle stamps a `state/orchestrator.log`
# summary; each script has its own detailed log in /tmp.
#
# Usage:
#   scripts/local-overnight-orchestrator.sh                # forever
#   scripts/local-overnight-orchestrator.sh --cycles 3     # exactly 3 cycles
#   scripts/local-overnight-orchestrator.sh --sleep 1800   # sleep 30m between
#
# Flags forwarded per-cycle:
#   --inline-limit N   passed to local-auto-update-inline.sh --limit
#   --skip-nixpkgs     don't run local-auto-update.sh this run
#   --skip-inline      don't run local-auto-update-inline.sh this run
#   --skip-expand      don't run local-nvchecker-coverage-expand.sh this run

set -uo pipefail

cd "$(git rev-parse --show-toplevel)"

CYCLES=0            # 0 = forever
SLEEP=900           # 15 minutes
INLINE_LIMIT=500
SKIP_NIXPKGS=0
SKIP_INLINE=0
SKIP_EXPAND=0
COMMIT_AND_PUSH=0
COMMIT_BRANCH="auto-update-nightly"

while [ $# -gt 0 ]; do
  case "$1" in
    --cycles)         CYCLES="$2"; shift 2 ;;
    --sleep)          SLEEP="$2"; shift 2 ;;
    --inline-limit)   INLINE_LIMIT="$2"; shift 2 ;;
    --skip-nixpkgs)   SKIP_NIXPKGS=1; shift ;;
    --skip-inline)    SKIP_INLINE=1; shift ;;
    --skip-expand)    SKIP_EXPAND=1; shift ;;
    --commit-and-push) COMMIT_AND_PUSH=1; shift ;;
    --commit-branch)  COMMIT_BRANCH="$2"; shift 2 ;;
    -h|--help)        sed -n '1,45p' "$0"; exit 0 ;;
    *)                echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

mkdir -p state
STATE_LOG="state/orchestrator.log"

reclaim_if_tight() {
  local free
  free=$(df -BG /nix | awk 'NR==2 {gsub("G","",$4); print $4}')
  if [ "$free" -lt 15 ]; then
    echo "[$(date -u +%FT%TZ)] /nix has ${free}G free — running nix-collect-garbage --delete-older-than 3d" | tee -a "$STATE_LOG"
    nix-collect-garbage --delete-older-than 3d >/tmp/nix-gc.log 2>&1 || true
  fi
}

log_stamp() {
  echo "[$(date -u +%FT%TZ)] $*" | tee -a "$STATE_LOG"
}

cycle=0
while true; do
  cycle=$((cycle + 1))
  log_stamp "===== cycle $cycle begin ====="
  reclaim_if_tight

  if [ "$SKIP_EXPAND" -eq 0 ]; then
    log_stamp "step 1/3: coverage expand"
    if scripts/local-nvchecker-coverage-expand.sh >/tmp/orch-expand.log 2>&1; then
      added=$(grep -oE '^wrote [0-9]+' /tmp/orch-expand.log | head -1 || echo "wrote 0")
      log_stamp "  expand: $added new nvchecker entries"
    else
      log_stamp "  expand: FAILED (see /tmp/orch-expand.log)"
    fi
  fi

  if [ "$SKIP_INLINE" -eq 0 ]; then
    log_stamp "step 2/3: inline auto-update (limit=$INLINE_LIMIT)"
    if scripts/local-auto-update-inline.sh --limit "$INLINE_LIMIT" >/tmp/orch-inline.log 2>&1; then
      bumped=$(grep -cE '^\+.*bumped' /tmp/orch-inline.log || true)
      log_stamp "  inline: completed"
    else
      log_stamp "  inline: exited non-zero (see /tmp/orch-inline.log)"
    fi
  fi

  reclaim_if_tight

  if [ "$SKIP_NIXPKGS" -eq 0 ]; then
    log_stamp "step 3/3: nixpkgs overlay bumps (flake + pkgs/_update.nix)"
    if scripts/local-auto-update.sh >/tmp/orch-nixpkgs.log 2>&1; then
      upd=$(grep -cE '^-' updated.md 2>/dev/null || echo 0)
      log_stamp "  nixpkgs: ${upd:-0} packages bumped"
    else
      log_stamp "  nixpkgs: exited non-zero (see /tmp/orch-nixpkgs.log)"
    fi
  fi

  if [ "$COMMIT_AND_PUSH" -eq 1 ]; then
    # Stage image bumps + nvchecker state + flake.lock; skip runtime scan
    # artifacts (tags-data / scan-data) that a background scan may be writing.
    added=$(git status --short \
      | grep -vE '^\?\?|website/tags-data/|website/scan-data/|scan-data/' \
      | grep -E '^ ?M (flake\.lock|nvchecker(\.toml|-images\.json)|old_versions\.json|new_versions\.json|(images|pkgs)/)' \
      | awk '{print $2}')
    if [ -n "$added" ]; then
      echo "$added" | xargs -r git add
      # Only push if the staged tree is non-empty
      if ! git diff --cached --quiet; then
        SUMMARY=$(git diff --cached --name-only | wc -l)
        MSG="chore(auto-update): cycle $cycle — $SUMMARY files bumped by orchestrator"
        if git -c user.name=itpick -c user.email=lucaspick@gmail.com commit -m "$MSG" >>/tmp/orch-commit.log 2>&1; then
          log_stamp "  commit: $SUMMARY files"
          # Ensure branch exists locally; then push (creates upstream branch on first push).
          git branch -f "$COMMIT_BRANCH" HEAD >/dev/null 2>&1 || true
          # --force-with-lease so a re-based auto-update-nightly (e.g. after
          # main was updated separately) doesn't fatally reject the push. The
          # branch is auto-generated per-cycle; overwriting is safe.
          if git push --force-with-lease -u origin "$COMMIT_BRANCH":"$COMMIT_BRANCH" >>/tmp/orch-commit.log 2>&1; then
            log_stamp "  push: $COMMIT_BRANCH → origin"
          else
            log_stamp "  push: FAILED (see /tmp/orch-commit.log)"
          fi
        else
          log_stamp "  commit: FAILED (see /tmp/orch-commit.log)"
        fi
      fi
    else
      log_stamp "  commit: nothing to stage"
    fi
  fi

  log_stamp "===== cycle $cycle end ====="

  if [ "$CYCLES" -gt 0 ] && [ "$cycle" -ge "$CYCLES" ]; then
    log_stamp "cycles budget exhausted, exiting"
    exit 0
  fi

  log_stamp "sleeping ${SLEEP}s before next cycle"
  sleep "$SLEEP"
done
