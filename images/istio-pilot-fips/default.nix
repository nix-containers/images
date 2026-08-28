# istio-pilot-fips (istiod control plane)
# https://istio.io/

{ mkImage, pkgs, lib, ... }:

# WAS A STUB. Before this, imagePkgs was exactly
#   [ bash coreutils cacert tzdata ]
# with no istio binary and no entrypoint, so the published image could not run
# anything. It was byte-identical to istio-proxy-fips, istio-pilot-agent-fips
# and istio-pilot-discovery-fips — all four shared one 24.3 MB layer
# (sha256:443340a3befa…) because they all built the same bash+coreutils closure
# under different names. Anyone pinning it got an empty image.
#
# NOT FIPS, AND THE NAME OVERSTATES IT. This packages pilot-discovery as
# extracted from the official Istio release image (see pkgs/istio), which is a
# stock upstream build. Nothing here links BoringCrypto, so the FIPS-140-2
# compliance label has been removed rather than left to be cited as evidence.
# istio-envoy-fips already states the same thing in its own comment.
#
# TO MAKE IT GENUINELY FIPS, pilot-discovery is pure Go, so it can follow the
# same shape as the 286 images in this repo that qualify: build from
# istio/istio source with buildGoModule, CGO_ENABLED = 1 and
# GOEXPERIMENT = "boringcrypto" (see age-fips). That is a real change of
# strategy for this package — pkgs/istio deliberately extracts prebuilt
# binaries because "Envoy doesn't build reliably in nixpkgs (bazel issues on
# aarch64)" — and it is left as follow-up rather than guessed at here.
#
# The Envoy data plane cannot be fixed that way at all: it is C++, so
# GOEXPERIMENT does nothing for it and it needs a Bazel --define boringssl=fips
# build. That is the half that terminates external TLS.

let
  istio = pkgs.istio;
  version = istio.version;
in
mkImage {
  drv = istio.pilot-discovery;
  name = "istio-pilot-fips";
  tag = version;
  entrypoint = [ "${istio.pilot-discovery}/bin/pilot-discovery" ];
  cmd = [ "discovery" ];

  extraPkgs = with pkgs; [
    busybox
    cacert
    iptables
  ];

  env = {
    PILOT_TRACE_SAMPLING = "1.0";
  };

  labels = {
    "org.opencontainers.image.title" = "Istio Pilot (fips-named, not FIPS)";
    "org.opencontainers.image.description" =
      "Istio control plane (istiod). Stock upstream build — no FIPS crypto backend.";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "istio";
  };
}
