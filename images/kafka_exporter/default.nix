{ mkImage, pkgs, lib, ... }:

# kafka_exporter - Prometheus exporter for Apache Kafka (danielqsj/kafka_exporter)
# https://github.com/danielqsj/kafka_exporter
#
# Prior revision consumed the upstream prebuilt tarball, which was Go
# stdlib v1.24.0-stale (crit CVEs). Rebuild from source at the same tag
# so the current nixpkgs Go toolchain patches stdlib forward.

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

    # Upstream vendor/modules.txt drifts from go.mod; use proxyVendor to
    # re-fetch modules through the Go proxy instead of the committed tree.
    proxyVendor = true;
    vendorHash = "sha256-J3MkLIVAOg5n/p/pn3Nj/PcoR40ohhUjmSMnkOEkEH4=";

    subPackages = [ "." ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };

in mkImage {
  inherit drv;
  name = "kafka_exporter";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/kafka_exporter" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "kafka_exporter";
    "org.opencontainers.image.description" = "Kafka exporter for Prometheus";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
