{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# flux-image-reflector-controller
# Flux GitOps component

let
  version = "1.2.3";
  flux-component = buildGoModule {
    pname = "flux-image-reflector-controller";
    inherit version;

    src = fetchFromGitHub {
      owner = "fluxcd";
      repo = "image-reflector-controller";
      rev = "v${version}";
      hash = "sha256-BL/DP5KOvY2LOArZCXXMdHTVqIgHz3No+ZlkfCPslqE=";
    };

    vendorHash = "sha256-uXEX0nltxHhcwisbDY7nBAJ6ulbFdTz4IlCa90UbZC4=";
    subPackages = [ "." ];
    
    env.CGO_ENABLED = 0;
    env.GOTOOLCHAIN = "local";

    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };

in
mkImage {
  drv = flux-component;
  name = "flux-image-reflector-controller";
  tag = "v${version}";
  entrypoint = [ "${flux-component}/bin/image-reflector-controller" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert git ];

  labels = {
    "org.opencontainers.image.title" = "flux image reflector controller";
    "org.opencontainers.image.description" = "Flux GitOps flux-image-reflector-controller";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "flux";
  };
}