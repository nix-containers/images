{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# jaeger-anonymizer-fips
# Jaeger distributed tracing

let
  version = "2.19.0";
  component = buildGoModule {
    pname = "jaeger-anonymizer-fips";
    inherit version;
    src = fetchFromGitHub {
      owner = "jaegertracing";
      repo = "jaeger";
      rev = "v${version}";
      hash = "sha256-tgwKArEpOkfajuASakBjF4pMVXIJr71HYSNdigkgrzs=";
    };
    vendorHash = "sha256-g65r1xT70H0YPgmgIVxVEc19nAFBQQZTugRNEXLaqMM=";
    subPackages = [ "." ];
    env.CGO_ENABLED = 1;
    env.GOEXPERIMENT = "boringcrypto";
    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };

in mkImage {
  drv = component;
  name = "jaeger-anonymizer-fips";
  tag = "v${version}";
  entrypoint = [ "${component}/bin/jaeger-anonymizer" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.title" = "jaeger-anonymizer-fips";
    "org.opencontainers.image.description" = "Jaeger jaeger-anonymizer";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "jaeger";
    "io.nix-containers.compliance" = "FIPS-140-2";
  };
}