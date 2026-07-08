{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# prometheus-config-reloader-fips
# Prometheus ecosystem component

let
  version = "0.92.1";
  prometheus-component = buildGoModule {
    pname = "prometheus-config-reloader-fips";
    inherit version;

    src = fetchFromGitHub {
      owner = "prometheus-operator";
      repo = "prometheus-operator";
      rev = "v0.92.1";
      hash = "sha256-z2dUojKghsqtIM5dWj0CxVRGcjBWlO8tLLGqj8LfaxU=";
    };

    vendorHash = null;
    subPackages = [ "cmd/prometheus-config-reloader" ];
    
    env.CGO_ENABLED = 1;
    env.GOEXPERIMENT = "boringcrypto";

    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };

in
mkImage {
  drv = prometheus-component;
  name = "prometheus-config-reloader-fips";
  tag = "v${version}";
  entrypoint = [ "${prometheus-component}/bin/config-reloader" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert tzdata ];

  labels = {
    "org.opencontainers.image.title" = "prometheus config reloader";
    "org.opencontainers.image.description" = "Prometheus prometheus-config-reloader component";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "prometheus";
    "io.nix-containers.compliance" = "FIPS-140-2";
  };
}
