{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# jaeger-ingester
# Jaeger distributed tracing

let
  version = "2.19.0";
  component = buildGoModule {
    pname = "jaeger-ingester";
    inherit version;
    src = fetchFromGitHub {
      owner = "jaegertracing";
      repo = "jaeger";
      rev = "v${version}";
      hash = "sha256-tgwKArEpOkfajuASakBjF4pMVXIJr71HYSNdigkgrzs=";
    };
    vendorHash = "sha256-g65r1xT70H0YPgmgIVxVEc19nAFBQQZTugRNEXLaqMM=";
    subPackages = [ "." ];
    env.CGO_ENABLED = 0;
    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };

in mkImage {
  drv = component;
  name = "jaeger-ingester";
  tag = "v${version}";
  entrypoint = [ "${component}/bin/jaeger-ingester" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.title" = "jaeger-ingester";
    "org.opencontainers.image.description" = "Jaeger jaeger-ingester";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "jaeger";
  };
}