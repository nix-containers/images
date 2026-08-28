# istio-proxyv2-fips (Istio sidecar / gateway proxy)
# https://istio.io/
#
# PARTIAL FIPS, AND THE SPLIT MATTERS. proxyv2 is a combined image: pilot-agent
# is the entrypoint and it execs Envoy. Only one of those two can be a FIPS
# build today:
#
#   pilot-agent  BoringCrypto (pkgs.istio-fips, GOEXPERIMENT=boringcrypto)  FIPS
#   envoy        stock upstream prebuilt from the istio-build bucket         NOT
#
# Envoy is C++, so GOEXPERIMENT does nothing for it; a validated build needs
# Bazel --define boringssl=fips against the frozen FIPS BoringSSL, which nixpkgs
# does not expose and this repo deliberately avoids (see pkgs/istio's header).
#
# ENVOY TERMINATES EXTERNAL TLS at the ingress gateway. So this image does NOT
# make the edge FIPS. It makes the agent that configures the edge FIPS. Anyone
# mapping this to a control that says "cryptographic module validated" should
# read the two-line table above and stop there.
#
# Both halves come from the same release: pilot-agent from istio/istio 1.30.4
# source, envoy from PROXY_REPO_SHA as pinned in that tag's istio.deps — not a
# mix of versions.

{ mkImage, pkgs, lib, ... }:

let
  istio = pkgs.istio-fips;
  version = istio.version;
in
mkImage {
  drv = istio.proxyv2-bin;
  name = "istio-proxyv2-fips";
  tag = version;
  entrypoint = [ "${istio.proxyv2-bin}/bin/pilot-agent" ];
  cmd = [ "proxy" "sidecar" ];

  extraPkgs = with pkgs; [
    cacert
    # Exposes the bundle as /etc/ssl/certs/ca-certificates.crt, the first path
    # pilot-agent's security.GetOSRootFilePath() probes. cacert alone installs
    # it as ca-bundle.crt, which matches none of istio's candidates, so every
    # proxy logged "OS CA Cert could not be found for agent".
    istio-fips.osCaCompat
    iptables
    iproute2
  ];

  noBusybox = true; # iproute2 conflicts with busybox

  env = {
    PATH = "/bin:${pkgs.iptables}/bin:${pkgs.iproute2}/bin";
  };

  labels = {
    "org.opencontainers.image.title" = "Istio Proxy (pilot-agent FIPS, Envoy not)";
    "org.opencontainers.image.description" =
      "Istio proxyv2: BoringCrypto pilot-agent with stock upstream Envoy. Envoy is not a FIPS build.";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "istio";
    # No io.nix-containers.compliance label on purpose. The image contains a
    # non-FIPS Envoy and Envoy is what terminates TLS here, so claiming
    # FIPS-140-2 for the image would be the exact overstatement this branch is
    # removing elsewhere.
  };
}
