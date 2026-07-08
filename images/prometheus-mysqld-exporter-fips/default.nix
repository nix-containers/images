{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# prometheus-mysqld-exporter-fips
# Prometheus ecosystem component

let
  version = "0.19.0";
  prometheus-component = buildGoModule {
    pname = "prometheus-mysqld-exporter-fips";
    inherit version;

    src = fetchFromGitHub {
      owner = "prometheus";
      repo = "mysqld_exporter";
      rev = "v0.19.0";
      hash = "sha256-1K0Xtj7VRAMQK5wgFGj7Yvzae6wVi9wWu1UcnEmpQJU=";
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
  name = "prometheus-mysqld-exporter-fips";
  tag = "v${version}";
  entrypoint = [ "${prometheus-component}/bin/mysqld-exporter" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert tzdata ];

  labels = {
    "org.opencontainers.image.title" = "prometheus mysqld exporter";
    "org.opencontainers.image.description" = "Prometheus prometheus-mysqld-exporter component";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "prometheus";
    "io.nix-containers.compliance" = "FIPS-140-2";
  };
}
