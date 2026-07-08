{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# prometheus-redis-exporter-fips
# Prometheus ecosystem component

let
  version = "1.86.0";
  prometheus-component = buildGoModule {
    pname = "prometheus-redis-exporter-fips";
    inherit version;

    src = fetchFromGitHub {
      owner = "oliver006";
      repo = "redis_exporter";
      rev = "v1.86.0";
      hash = "sha256-N7IW1u/ifo8S0yRmdRYFAXfqke/GUVy5omrEqaCZ/3I=";
    };

    vendorHash = null;
    subPackages = [ "." ];
    
    env.CGO_ENABLED = 1;
    env.GOEXPERIMENT = "boringcrypto";

    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };

in
mkImage {
  drv = prometheus-component;
  name = "prometheus-redis-exporter-fips";
  tag = "v${version}";
  entrypoint = [ "${prometheus-component}/bin/redis-exporter" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert tzdata ];

  labels = {
    "org.opencontainers.image.title" = "prometheus redis exporter";
    "org.opencontainers.image.description" = "Prometheus prometheus-redis-exporter component";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "prometheus";
    "io.nix-containers.compliance" = "FIPS-140-2";
  };
}
