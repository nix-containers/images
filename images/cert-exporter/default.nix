{ mkImage, pkgs, lib, ... }:

# cert-exporter - Prometheus exporter for certificate expiry metrics
# https://github.com/joe-elliott/cert-exporter
#
# Prior revision consumed the upstream prebuilt Linux tarball, which is
# Go-stdlib v1.25.5 stale. Rebuild from source with the current nixpkgs
# Go toolchain so stdlib patches forward at each build.

let
  version = "2.18.0";

  drv = pkgs.buildGoModule {
    pname = "cert-exporter";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "joe-elliott";
      repo = "cert-exporter";
      rev = "v${version}";
      hash = "sha256-Z/CgELExvd144IroAFmwEJcxdRvzrSl3GL2IaORk3nI=";
    };

    # Upstream vendor/modules.txt drifts from go.mod; use proxyVendor.
    proxyVendor = true;
    vendorHash = "sha256-XBiw5aZ56nAkCqphuo+AoU7K3BpkoKLGea2uJVgRR/Q=";

    subPackages = [ "." ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in
mkImage {
  inherit drv;
  name = "cert-exporter";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/cert-exporter" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "cert-exporter";
    "org.opencontainers.image.description" = "Prometheus exporter for certificate expiry metrics";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
