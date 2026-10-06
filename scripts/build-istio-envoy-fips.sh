#!/usr/bin/env bash
# Rebuild the AWS-LC-FIPS Envoy that pkgs/istio-fips fetches.
#
# WHY THIS SCRIPT EXISTS. Nothing publishes a FIPS Envoy that Istio can use.
# Chainguard's envoy-fips is UPSTREAM Envoy, and Istio's data plane needs
# istio/proxy's build: the bootstrap requires
# type.googleapis.com/istio.workload.BootstrapExtension and the binary must
# carry io.istio.http.peer_metadata, io.istio.local_principal and
# io.istio.peer_principal. A vanilla FIPS Envoy rejects Istio's config outright.
# Google's ASM publishes no FIPS variant; Tetrate's is subscription-gated.
#
# The build cannot run inside a nix derivation: it is a ~60 minute Bazel build
# needing network access mid-build and its own clang/cmake/ninja/go toolchain.
# So the binary is built here, attached to a GitHub release, and fetched by hash
# in pkgs/istio-fips. That keeps the IMAGE reproducible from git while the
# binary stays a documented, hash-pinned input.
#
# THE MODULE: AWS-LC 3 Cryptographic Module (static), AWS-LC FIPS 3.1.0,
# NIST CMVP #5314 (FIPS 140-3 L1). Two stages:
#   1. libcrypto.a/libssl.a built EXACTLY per Security Policy section 11.1:
#      Amazon Linux 2023, "Development Tools" + cmake3 + golang,
#      `cmake3 -DFIPS=1 .. && make`, from the unmodified
#      AWS-LC-FIPS-3.1.0.zip (sha256 checked against the policy), then
#      `bssl isfips` must print 1. Envoy's own in-Bazel AWS-LC genrule is NOT
#      used: it compiles with a different compiler/flags than the policy's
#      method, and the Management Manual (7.9.2 fn 5) only allows a user
#      recompile that follows the policy's method without modification.
#   2. istio/proxy at PROXY_SHA with istio-envoy-awslc-fips/istio-proxy-*.patch:
#        WORKSPACE  @aws_lc -> new_local_repository on the stage-1 libraries
#                   + envoy patch 0014 (FIPS_202205 policy on AWS-LC, below)
#        BUILD      drop cryptomb/QAT key providers for AWS-LC (as istio/proxy
#                   already does for OpenSSL; they do key ops outside the module)
#      built with --config=release --config=aws-lc-fips (implies http3=False).
#
# PATCH 0014 (Envoy only, module untouched): AWS-LC lacks
# SSL_CTX_set_compliance_policy and Envoy's compat shim stubs it to fail, so a
# listener with compliance_policies: [FIPS_202205] would be rejected. 0014
# implements that policy with public AWS-LC APIs (TLS>=1.2; TLS1.2
# ECDHE-*-AES-GCM; TLS1.3 AES-GCM only; P-256/P-384; no SHA-1/Ed25519 sigalgs).
# AWS-LC cannot REQUIRE extended master secret, so that part is not emulated.
#
# Requirements: docker, ~60 GB free disk, ~20 cores recommended.
#
# THREE THINGS THAT WILL WASTE YOUR TIME IF YOU DO NOT KNOW THEM:
#   1. `build-tools` has NO bazel. The proxy repo needs `build-tools-proxy`.
#   2. `--define boringssl=fips` was REMOVED from Envoy; FIPS builds use
#      `--config=boringssl-fips` / `--config=aws-lc-fips`.
#   3. bazel needs `git config --global --add safe.directory` on a bind mount.
#
# OPERATIONAL ENVIRONMENT: #5314 lists Amazon Linux 2023 only, with no
# vendor-affirmed OEs. Running on another Linux (e.g. GKE COS) is a USER
# affirmation (FIPS 140-3 Management Manual 7.9.2); CMVP makes no statement
# about correct operation on unlisted OEs.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
PATCHDIR="$HERE/istio-envoy-awslc-fips"
PROXY_SHA="${PROXY_SHA:-ce177c56fe75661f16b654e2f164d4ab02058222}"
ISTIO_TAG="${ISTIO_TAG:-1.30.4}"
IMG="${IMG:-registry.istio.io/testing/build-tools-proxy:release-1.30-ad8991a47cf3c61799caa5569b9458d95eb612f2}"
AL2023="${AL2023:-amazonlinux:2023}"
WORK="${WORK:-/tmp/istio-envoy-awslc-fips-build}"
AWSLC_ZIP_URL="https://github.com/aws/aws-lc/archive/refs/tags/AWS-LC-FIPS-3.1.0.zip"
AWSLC_ZIP_SHA256="fe408fa438850786396faf79eba9ea4116c3802e60f3a95865f0dd2adb64c9f1" # SP 11.1

echo "==> istio ${ISTIO_TAG}, proxy ${PROXY_SHA}, AWS-LC FIPS 3.1.0 (CMVP #5314)"
mkdir -p "$WORK/bazel-out" "$WORK/bazel-cache" "$WORK/sp-build" "$WORK/awslc-prebuilt"

# ---- stage 1: the module, per Security Policy 11.1 ----
curl -fsSL -o "$WORK/sp-build/AWS-LC-FIPS-3.1.0.zip" "$AWSLC_ZIP_URL"
echo "$AWSLC_ZIP_SHA256  $WORK/sp-build/AWS-LC-FIPS-3.1.0.zip" | sha256sum -c -
cp "$PATCHDIR/build-aws-lc-per-security-policy.sh" "$WORK/sp-build/"
docker run --rm -v "$WORK/sp-build":/w "$AL2023" /w/build-aws-lc-per-security-policy.sh \
  | tee "$WORK/sp-build/sp-build.log" | grep -E '^ISFIPS='
grep -qx 'ISFIPS=1' "$WORK/sp-build/sp-build.log" \
  || { echo "ERROR: bssl isfips != 1" >&2; exit 1; }
SRC="$WORK/sp-build/aws-lc-AWS-LC-FIPS-3.1.0"
rm -rf "$WORK/awslc-prebuilt"/*
mkdir -p "$WORK/awslc-prebuilt/crypto" "$WORK/awslc-prebuilt/ssl"
cp -a "$SRC/include" "$WORK/awslc-prebuilt/"
cp "$SRC/build/crypto/libcrypto.a" "$WORK/awslc-prebuilt/crypto/"
cp "$SRC/build/ssl/libssl.a" "$WORK/awslc-prebuilt/ssl/"

# ---- stage 2: istio/proxy Envoy ----
if [ ! -d "$WORK/proxy/.git" ]; then
  git clone --filter=blob:none https://github.com/istio/proxy.git "$WORK/proxy"
fi
git -C "$WORK/proxy" fetch --depth 1 origin "$PROXY_SHA"
git -C "$WORK/proxy" checkout -f "$PROXY_SHA"
git -C "$WORK/proxy" clean -fdq
git -C "$WORK/proxy" apply "$PATCHDIR/istio-proxy-ce177c56-awslc-fips.patch"

docker run --rm -u 0:0 \
  -v "$WORK/proxy":/work \
  -v "$WORK/bazel-out":/bazel-out \
  -v "$WORK/bazel-cache":/root/.cache/bazel \
  -v "$WORK/awslc-prebuilt":/awslc-prebuilt:ro \
  -w /work "$IMG" \
  bash -c '
    git config --global --add safe.directory /work
    export USE_BAZEL_VERSION=7.7.1
    bazel --output_base=/bazel-out build \
      --config=release \
      --config=aws-lc-fips \
      --verbose_failures \
      --jobs="${JOBS:-20}" \
      --disk_cache=/root/.cache/bazel/disk \
      //:envoy
  '

BIN="$WORK/bazel-out/execroot/io_istio_proxy/bazel-out/k8-opt/bin/envoy"
echo "==> verifying the binary reports AWS-LC-FIPS and statically links the module"
docker run --rm -u 0:0 -v "$(dirname "$BIN")":/b:ro "$IMG" /b/envoy --version \
  | grep -q 'AWS-LC-FIPS' \
  || { echo "ERROR: binary does not report AWS-LC-FIPS" >&2; exit 1; }
nm "$BIN" | grep -q ' T awslc_version_string$' \
  || { echo "ERROR: awslc_version_string not statically linked" >&2; exit 1; }
strings -a "$BIN" | grep -qx 'AWS-LC FIPS 3.1.0' \
  || { echo "ERROR: module version string 'AWS-LC FIPS 3.1.0' missing" >&2; exit 1; }

ASSET="$WORK/istio-envoy-awslc-fips-3.1.0-${PROXY_SHA}.gz"
echo "==> sha256 (uncompressed): $(sha256sum "$BIN" | awk '{print $1}')"
gzip -1 -n -c "$BIN" > "$ASSET"
echo "==> asset: $ASSET"
echo
echo "Next: attach it to a NEW release (never replace an existing asset) and"
echo "update the url/hash in pkgs/istio-fips:"
echo "  gh release create istio-envoy-awslc-fips-${ISTIO_TAG} --repo nix-containers/images \\"
echo "    \"$ASSET\""
echo "  nix hash file --type sha256 --sri \"$ASSET\""
