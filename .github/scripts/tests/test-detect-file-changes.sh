#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT="$SCRIPT_DIR/../detect-file-changes.sh"

# Fixture: pretend the repo has these two images discovered
export FULL_MATRIX='{"include":[{"name":"postgres-fips","path":"images/postgres-fips/"},{"name":"redis","path":"images/redis/"}]}'

PASS=0
FAIL=0

assert_eq() {
  local name="$1" expected="$2" actual="$3"
  # Normalize via jq so key ordering doesn't matter
  local exp_norm act_norm
  exp_norm=$(printf '%s' "$expected" | jq -cS .)
  act_norm=$(printf '%s' "$actual" | jq -cS .)
  if [ "$exp_norm" = "$act_norm" ]; then
    printf 'PASS: %s\n' "$name"
    PASS=$((PASS + 1))
  else
    printf 'FAIL: %s\n' "$name"
    printf '  expected: %s\n' "$exp_norm"
    printf '  actual:   %s\n' "$act_norm"
    FAIL=$((FAIL + 1))
  fi
}

run() {
  # $1 = newline-separated changed paths
  printf '%s' "$1" | "$SCRIPT"
}

# --- Tests ---

test_per_image_single() {
  local out
  out=$(run "images/postgres-fips/test.nix")
  assert_eq "per-image single file" \
    '{"changes-detected":"true","changed-images":{"include":[{"name":"postgres-fips","path":"images/postgres-fips/"}]},"rebuild-all":"false"}' \
    "$out"
}

test_per_image_single

test_per_image_multiple() {
  local out
  out=$(run "images/postgres-fips/default.nix
images/redis/default.nix")
  assert_eq "per-image multiple files" \
    '{"changes-detected":"true","changed-images":{"include":[{"name":"postgres-fips","path":"images/postgres-fips/"},{"name":"redis","path":"images/redis/"}]},"rebuild-all":"false"}' \
    "$out"
}

test_per_image_dedup() {
  local out
  out=$(run "images/postgres-fips/default.nix
images/postgres-fips/test.nix
images/postgres-fips/docker-entrypoint.sh")
  assert_eq "per-image de-dup multiple files in same image" \
    '{"changes-detected":"true","changed-images":{"include":[{"name":"postgres-fips","path":"images/postgres-fips/"}]},"rebuild-all":"false"}' \
    "$out"
}

test_per_image_unknown_filtered() {
  # images/deleted-foo/ no longer exists in FULL_MATRIX — must be dropped
  local out
  out=$(run "images/deleted-foo/default.nix
images/postgres-fips/test.nix")
  assert_eq "per-image unknown name filtered out" \
    '{"changes-detected":"true","changed-images":{"include":[{"name":"postgres-fips","path":"images/postgres-fips/"}]},"rebuild-all":"false"}' \
    "$out"
}

test_per_image_multiple
test_per_image_dedup
test_per_image_unknown_filtered

printf '\n%d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
