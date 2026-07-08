{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# flux-image-reflector-controller
# Flux GitOps component

let
  version = "1.2.2";
  flux-component = buildGoModule {
    pname = "flux-image-reflector-controller";
    inherit version;

    src = fetchFromGitHub {
      owner = "fluxcd";
      repo = "image-reflector-controller";
      rev = "v${version}";
      hash = "sha256-hKHJDT7psAQ0uJhaU9s6Nq1qGj+EJllReeFEd41mhCY=";
    };

    vendorHash = "sha256-XQmcDmmOCJRVp0MW/hjpu02UYxC2nsrpvctnE6aQtqI=";
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