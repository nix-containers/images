{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# prometheus-mongodb-exporter-fips
# Prometheus ecosystem component

let
  version = "0.51.0";
  prometheus-component = buildGoModule {
    pname = "prometheus-mongodb-exporter-fips";
    inherit version;

    src = fetchFromGitHub {
      owner = "percona";
      repo = "mongodb_exporter";
      rev = "v0.51.0";
      hash = "sha256-FpB1xijoKoKTCteHhuPakej4PkYXcuPMD9Vmc7B6/vs=";
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
  name = "prometheus-mongodb-exporter-fips";
  tag = "v${version}";
  entrypoint = [ "${prometheus-component}/bin/mongodb-exporter" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert tzdata ];

  labels = {
    "org.opencontainers.image.title" = "prometheus mongodu exporter";
    "org.opencontainers.image.description" = "Prometheus prometheus-mongodb-exporter component";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "prometheus";
    "io.nix-containers.compliance" = "FIPS-140-2";
  };
}
