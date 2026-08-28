# istio-pilot-agent-fips
# https://istio.io/

{ mkImage, pkgs, lib, ... }:

# GENUINELY FIPS, unlike every other istio-*-fips image before this. It uses
# pkgs.istio-fips, which builds pilot-agent from istio/istio source with
# CGO_ENABLED=1 and GOEXPERIMENT=boringcrypto, rather than pkgs.istio, which
# extracts a stock prebuilt binary out of the official release image. Extraction
# can never yield a FIPS artifact, which is why the compliance label is earned
# here and was removed from the images that only carried the name.
#
# Verify, do not assume:
#   go version -m /path/to/pilot-agent | grep GOEXPERIMENT
# must report boringcrypto, and the binary self-reports
# GolangVersion:"goX.Y.Z-X:boringcrypto" under `pilot-agent version`.
#
# THE EDGE IS STILL NOT COVERED. Envoy is C++; GOEXPERIMENT does nothing for it
# and it needs Bazel --define boringssl=fips against the frozen FIPS-validated
# BoringSSL. istio-proxy-fips and istio-envoy-fips remain stock upstream and are
# labelled accordingly. External TLS terminates in Envoy, so this covers the
# control plane, xDS and mTLS crypto — not the ingress gateway.

let
  istio = pkgs.istio-fips;
  version = istio.version;
in
mkImage {
  drv = istio.pilot-agent;
  name = "istio-pilot-agent-fips";
  tag = version;
  entrypoint = [ "${istio.pilot-agent}/bin/pilot-agent" ];

  extraPkgs = with pkgs; [
    busybox
    cacert
    iptables
  ];

  labels = {
    "org.opencontainers.image.title" = "Istio pilot-agent (FIPS/BoringCrypto)";
    "org.opencontainers.image.description" = "Istio sidecar agent, built with GOEXPERIMENT=boringcrypto";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "istio";
    # Earned: the binary in this image is a BoringCrypto build. See the header.
    "io.nix-containers.compliance" = "FIPS-140-2";
  };
}
