{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# cert-manager-startupapicheck-fips
# cert-manager component

let
  version = "1.20.3";
  component = buildGoModule {
    pname = "cert-manager-startupapicheck-fips";
    inherit version;
    src = fetchFromGitHub {
      owner = "cert-manager";
      repo = "cert-manager";
      rev = "v${version}";
      hash = "sha256-YNTaUrtq2FUt8DTzNJaOyuNrlOPkUUx0CeImfGL5+Io=";
    };
    vendorHash = "sha256-WIody/rEIDCtwCxrPmtX1+OP5Cs8kpRorUVDs3StLVo=";
    subPackages = [ "." ];
    env.CGO_ENABLED = 1;
    env.GOEXPERIMENT = "boringcrypto";
    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };

in mkImage {
  drv = component;
  name = "cert-manager-startupapicheck-fips";
  tag = "v${version}";
  entrypoint = [ "${component}/bin/cert-manager-startupapicheck" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.title" = "cert-manager-startupapicheck-fips";
    "org.opencontainers.image.description" = "cert-manager cert-manager-startupapicheck";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "cert-manager";
    "io.nix-containers.compliance" = "FIPS-140-2";
  };
}