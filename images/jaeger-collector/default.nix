{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# jaeger-collector
# Jaeger distributed tracing

let
  version = "2.0.0";
  component = buildGoModule {
    pname = "jaeger-collector";
    inherit version;
    src = fetchFromGitHub {
      owner = "jaegertracing";
      repo = "jaeger";
      rev = "v${version}";
      hash = "sha256-DQa/BlMC9RECwLVAZ0kN2O5w1ppJbg5NuDhQ/zXXGuc=";
    };
    vendorHash = "sha256-g1Rc+0XX7P6/PT7NNAuhFCLCyB7nykb+DkbSA6CMdXc=";
    subPackages = [ "." ];
    env.CGO_ENABLED = 0;
    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };

in mkImage {
  drv = component;
  name = "jaeger-collector";
  tag = "v${version}";
  entrypoint = [ "${component}/bin/jaeger-collector" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.title" = "jaeger-collector";
    "org.opencontainers.image.description" = "Jaeger jaeger-collector";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "jaeger";
  };
}