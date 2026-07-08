{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# prometheus-pgbouncer-exporter-fips
# Prometheus ecosystem component

let
  version = "0.12.1";
  prometheus-component = buildGoModule {
    pname = "prometheus-pgbouncer-exporter-fips";
    inherit version;

    src = fetchFromGitHub {
      owner = "prometheus-community";
      repo = "pgbouncer_exporter";
      rev = "v0.12.1";
      hash = "sha256-P82ek6+OcvRd1dIuqkfqU4DEmOtHVkSfN5atLansCK4=";
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
  name = "prometheus-pgbouncer-exporter-fips";
  tag = "v${version}";
  entrypoint = [ "${prometheus-component}/bin/pgbouncer-exporter" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert tzdata ];

  labels = {
    "org.opencontainers.image.title" = "prometheus pguouncer exporter";
    "org.opencontainers.image.description" = "Prometheus prometheus-pgbouncer-exporter component";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "prometheus";
    "io.nix-containers.compliance" = "FIPS-140-2";
  };
}
