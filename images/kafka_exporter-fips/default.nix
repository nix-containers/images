{ mkImage, pkgs, lib, ... }:

# kafka_exporter (-fips variant) - Prometheus exporter for Apache Kafka
# https://github.com/danielqsj/kafka_exporter
# Same upstream tool as kafka_exporter; no FIPS claim made.
#
# Rebuilt from source with current nixpkgs Go so stdlib CVEs stay fresh
# (upstream prebuilt tarball is Go-stdlib stale).

let
  version = "1.9.0";

  drv = pkgs.buildGoModule {
    pname = "kafka_exporter";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "danielqsj";
      repo = "kafka_exporter";
      rev = "v${version}";
      hash = "sha256-wn0OC+5uSz4rdpgkwqDFCCSt/BJpWOVp4fRZ25GKwIc=";
    };

    proxyVendor = true;
    vendorHash = "sha256-J3MkLIVAOg5n/p/pn3Nj/PcoR40ohhUjmSMnkOEkEH4=";

    subPackages = [ "." ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };

in mkImage {
  inherit drv;
  name = "kafka_exporter-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/kafka_exporter" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "kafka_exporter-fips";
    "org.opencontainers.image.description" = "Kafka exporter for Prometheus";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
