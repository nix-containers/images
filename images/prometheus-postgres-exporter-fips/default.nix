{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# prometheus-postgres-exporter-fips
# Prometheus ecosystem component

let
  version = "0.20.1";
  prometheus-component = buildGoModule {
    pname = "prometheus-postgres-exporter-fips";
    inherit version;

    src = fetchFromGitHub {
      owner = "prometheus-community";
      repo = "postgres_exporter";
      rev = "v0.20.1";
      hash = "sha256-uTY26VyFjU7DLn/fseGG1jgIkUAO0cF4lyeFoZ+UC5o=";
    };

    vendorHash = null;
    subPackages = [ "cmd/postgres_exporter" ];
    
    env.CGO_ENABLED = 1;
    env.GOEXPERIMENT = "boringcrypto";

    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };

in
mkImage {
  drv = prometheus-component;
  name = "prometheus-postgres-exporter-fips";
  tag = "v${version}";
  entrypoint = [ "${prometheus-component}/bin/postgres-exporter" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert tzdata ];

  labels = {
    "org.opencontainers.image.title" = "prometheus postgres exporter";
    "org.opencontainers.image.description" = "Prometheus prometheus-postgres-exporter component";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "prometheus";
    "io.nix-containers.compliance" = "FIPS-140-2";
  };
}
