#!/usr/bin/env bash
# Rebuild the BoringSSL-FIPS Envoy that pkgs/istio-fips fetches.
#
# WHY THIS SCRIPT EXISTS. Nothing publishes a FIPS Envoy that Istio can use.
# Chainguard's envoy-fips is UPSTREAM Envoy, and Istio's data plane needs
# istio/proxy's build: the bootstrap requires
# type.googleapis.com/istio.workload.BootstrapExtension and the binary must
# carry io.istio.http.peer_metadata, io.istio.local_principal and
# io.istio.peer_principal. A vanilla FIPS Envoy rejects Istio's config outright.
# Google's ASM publishes no FIPS variant; Tetrate's is subscription-gated.
#
# The build cannot run inside a nix derivation: it is a ~75 minute Bazel build
# needing network access mid-build and its own clang/cmake/ninja/go toolchain.
# So the binary is built here, attached to a GitHub release, and fetched by hash
# in pkgs/istio-fips. That keeps the IMAGE reproducible from git while the
# binary stays a documented, hash-pinned input.
#
# Requirements: docker, ~60 GB free disk, ~20 cores recommended (74 min on 24).
#
# THREE THINGS THAT WILL WASTE YOUR TIME IF YOU DO NOT KNOW THEM:
#   1. `build-tools` has NO bazel. The proxy repo needs `build-tools-proxy`.
#   2. `--define boringssl=fips` was REMOVED from Envoy. It is now
#      `--config=boringssl-fips`; Envoy's check_removed_fips_define target
#      errors out and tells you so.
#   3. bazel needs `git config --global --add safe.directory` on a bind mount.
#
# The genrule self-validates: cmake -DFIPS=1, then `ninja run_tests` and
# `./bssl isfips`, aborting unless isfips reports 1. A completed build is
# therefore evidence the module is in FIPS mode.
#
# WHAT THIS IS NOT: a CMVP-validated artifact. Certificates are issued by
# NIST/CCCS after an accredited CST lab tests a specific build; a self-built
# module inherits nobody's number. The image labels say fips.validated=false for
# this reason. To get a citable certificate, pin the dated snapshot a
# certificate covers (Chainguard pins 20240407 = CMVP #5104) and have a lab
# opine, or buy a vendor build.
set -euo pipefail

# PROXY_REPO_SHA from istio/istio's istio.deps at the istio tag you are
# targeting. Must match, or the Envoy will not pair with that istiod.
PROXY_SHA="${PROXY_SHA:-ce177c56fe75661f16b654e2f164d4ab02058222}"
ISTIO_TAG="${ISTIO_TAG:-1.30.4}"
IMG="${IMG:-registry.istio.io/testing/build-tools-proxy:release-1.30-ad8991a47cf3c61799caa5569b9458d95eb612f2}"
WORK="${WORK:-/tmp/istio-envoy-fips-build}"

echo "==> istio ${ISTIO_TAG}, proxy ${PROXY_SHA}"
mkdir -p "$WORK/bazel-out" "$WORK/bazel-cache"
if [ ! -d "$WORK/proxy/.git" ]; then
  git clone --filter=blob:none https://github.com/istio/proxy.git "$WORK/proxy"
fi
git -C "$WORK/proxy" fetch --depth 1 origin "$PROXY_SHA"
git -C "$WORK/proxy" checkout "$PROXY_SHA"

docker run --rm -u 0:0 \
  -v "$WORK/proxy":/work \
  -v "$WORK/bazel-out":/bazel-out \
  -v "$WORK/bazel-cache":/root/.cache/bazel \
  -w /work "$IMG" \
  bash -c '
    git config --global --add safe.directory /work
    bazel --output_base=/bazel-out build \
      --config=release \
      --config=boringssl-fips \
      --verbose_failures \
      --jobs="${JOBS:-20}" \
      --disk_cache=/root/.cache/bazel/disk \
      //:envoy
  '

BIN="$WORK/bazel-out/execroot/io_istio_proxy/bazel-out/k8-opt/bin/envoy"
echo "==> verifying the binary reports FIPS"
docker run --rm -u 0:0 -v "$(dirname "$BIN")":/b:ro "$IMG" /b/envoy --version \
  | grep -q 'BoringSSL-FIPS' \
  || { echo "ERROR: binary does not report BoringSSL-FIPS" >&2; exit 1; }

echo "==> sha256 (uncompressed): $(sha256sum "$BIN" | awk '{print $1}')"
gzip -1 -c "$BIN" > "$WORK/istio-envoy-fips-${PROXY_SHA}.gz"
echo "==> asset: $WORK/istio-envoy-fips-${PROXY_SHA}.gz"
echo
echo "Next: attach it to a release and update the hash in pkgs/istio-fips:"
echo "  gh release create istio-envoy-fips-${ISTIO_TAG} --repo nix-containers/images \\"
echo "    \"$WORK/istio-envoy-fips-${PROXY_SHA}.gz\""
echo "  nix-prefetch-url --type sha256 <asset-url> | xargs nix hash to-sri --type sha256"
