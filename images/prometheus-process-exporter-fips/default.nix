{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# prometheus-process-exporter-fips
# Prometheus ecosystem component

let
  version = "0.8.7";
  prometheus-component = buildGoModule {
    pname = "prometheus-process-exporter-fips";
    inherit version;

    src = fetchFromGitHub {
      owner = "ncabatoff";
      repo = "process-exporter";
      rev = "v0.8.7";
      hash = "sha256-dxXBhrZdYM+mH73K/cdaSmfzbzZaPJYCTzcfXGYMlyY=";
    };

    vendorHash = null;
    subPackages = [ "cmd/process-exporter" ];
    
    env.CGO_ENABLED = 1;
    env.GOEXPERIMENT = "boringcrypto";

    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };

in
mkImage {
  drv = prometheus-component;
  name = "prometheus-process-exporter-fips";
  tag = "v${version}";
  entrypoint = [ "${prometheus-component}/bin/process-exporter" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert tzdata ];

  labels = {
    "org.opencontainers.image.title" = "prometheus process exporter";
    "org.opencontainers.image.description" = "Prometheus prometheus-process-exporter component";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "prometheus";
    "io.nix-containers.compliance" = "FIPS-140-2";
  };
}
