{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# cert-manager-cmctl
# cert-manager component

let
  version = "1.20.3";
  component = buildGoModule {
    pname = "cert-manager-cmctl";
    inherit version;
    src = fetchFromGitHub {
      owner = "cert-manager";
      repo = "cert-manager";
      rev = "v${version}";
      hash = "sha256-YNTaUrtq2FUt8DTzNJaOyuNrlOPkUUx0CeImfGL5+Io=";
    };
    vendorHash = "sha256-WIody/rEIDCtwCxrPmtX1+OP5Cs8kpRorUVDs3StLVo=";
    subPackages = [ "." ];
    env.CGO_ENABLED = 0;
    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };

in mkImage {
  drv = component;
  name = "cert-manager-cmctl";
  tag = "v${version}";
  entrypoint = [ "${component}/bin/cert-manager-cmctl" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.title" = "cert-manager-cmctl";
    "org.opencontainers.image.description" = "cert-manager cert-manager-cmctl";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "cert-manager";
  };
}