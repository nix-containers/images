{ mkImage, pkgs, lib, ... }:

# cert-exporter - Prometheus exporter for certificate expiry metrics
# https://github.com/joe-elliott/cert-exporter
#
# Built from source (was upstream prebuilt binary, Go-stdlib stale). Force
# GOTOOLCHAIN=local so the current nixpkgs Go toolchain clears stdlib CVEs.
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

    vendorHash = "sha256-AJBf5asggN+QU2FR1ZmqVBNItQuVTTDY2sFekqcsOH8=";

    env.CGO_ENABLED = 0;
    preBuild = "export GOTOOLCHAIN=local";
    ldflags = [ "-s" "-w" ];
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
