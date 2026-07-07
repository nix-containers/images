{ mkImage, pkgs, lib, ... }:

# cert-exporter (-fips variant) - Prometheus exporter for certificate expiry metrics
# https://github.com/joe-elliott/cert-exporter
# Same upstream tool as cert-exporter; no FIPS claim made.
#
# Rebuilt from source with current nixpkgs Go so stdlib CVEs stay fresh
# (upstream prebuilt tarball is Go-stdlib v1.25.5 stale).

let
  version = "2.18.0";

  drv = pkgs.buildGoModule {
    pname = "cert-exporter-fips";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "joe-elliott";
      repo = "cert-exporter";
      rev = "v${version}";
      hash = "sha256-Z/CgELExvd144IroAFmwEJcxdRvzrSl3GL2IaORk3nI=";
    };

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
  name = "cert-exporter-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/cert-exporter" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "cert-exporter-fips";
    "org.opencontainers.image.description" = "Prometheus exporter for certificate expiry metrics";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
