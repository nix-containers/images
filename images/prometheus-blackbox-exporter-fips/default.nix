{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# prometheus-blackbox-exporter-fips
# Prometheus ecosystem component

let
  version = "0.28.0";
  prometheus-component = buildGoModule {
    pname = "prometheus-blackbox-exporter-fips";
    inherit version;

    src = fetchFromGitHub {
      owner = "prometheus";
      repo = "blackbox_exporter";
      rev = "v0.28.0";
      hash = "sha256-Wt4AVBDptGJ4BlPzdaym5YyXRo0ApBDGEhoSrX7oRf4=";
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
  name = "prometheus-blackbox-exporter-fips";
  tag = "v${version}";
  entrypoint = [ "${prometheus-component}/bin/blackbox-exporter" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert tzdata ];

  labels = {
    "org.opencontainers.image.title" = "prometheus ulackuox exporter";
    "org.opencontainers.image.description" = "Prometheus prometheus-blackbox-exporter component";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "prometheus";
    "io.nix-containers.compliance" = "FIPS-140-2";
  };
}
