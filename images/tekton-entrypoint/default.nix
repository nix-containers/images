{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# tekton-entrypoint
# Tekton CI/CD component

let
  version = "1.14.0";
  component = buildGoModule {
    pname = "tekton-entrypoint";
    inherit version;
    src = fetchFromGitHub {
      owner = "tektoncd";
      repo = "pipeline";
      rev = "v${version}";
      hash = "sha256-RfPCQ5Ug0EQkpUOEoJoFgFZ983Fp5bIZiVtRWmrNDVw=";
    };
    vendorHash = null;
    subPackages = [ "." ];
    env.CGO_ENABLED = 0;
    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };

in mkImage {
  drv = component;
  name = "tekton-entrypoint";
  tag = "v${version}";
  entrypoint = [ "${component}/bin/tekton-entrypoint" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert git ];
  labels = {
    "org.opencontainers.image.title" = "tekton-entrypoint";
    "org.opencontainers.image.description" = "Tekton tekton-entrypoint";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "tekton";
  };
}
