{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# prometheus-node-exporter-fips
# Prometheus ecosystem component

let
  version = "1.11.1";
  prometheus-component = buildGoModule {
    pname = "prometheus-node-exporter-fips";
    inherit version;

    src = fetchFromGitHub {
      owner = "prometheus";
      repo = "node_exporter";
      rev = "v1.11.1";
      hash = "sha256-AoW4JO9V/sZDjonNT+Ar8saX/rlb1lB/+Vmu5qGtTlA=";
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
  name = "prometheus-node-exporter-fips";
  tag = "v${version}";
  entrypoint = [ "${prometheus-component}/bin/node-exporter" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert tzdata ];

  labels = {
    "org.opencontainers.image.title" = "prometheus node exporter";
    "org.opencontainers.image.description" = "Prometheus prometheus-node-exporter component";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "prometheus";
    "io.nix-containers.compliance" = "FIPS-140-2";
  };
}
