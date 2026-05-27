#!/usr/bin/env bash
# Classify changed file paths into per-image and shared-rebuild-all buckets.
# Reads paths from stdin (one per line). Reads FULL_MATRIX env var (JSON of
# discovered images, shape: {"include":[{"name","path"},...]}).
# Writes classification JSON to stdout.
set -euo pipefail

# Stub — emits empty result so first test fails on content, not exit code.
printf '{"changes-detected":"false","changed-images":{"include":[]},"rebuild-all":"false"}\n'
