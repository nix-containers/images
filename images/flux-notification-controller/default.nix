{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# flux-notification-controller
# Flux GitOps component

let
  version = "1.9.2";
  flux-component = buildGoModule {
    pname = "flux-notification-controller";
    inherit version;

    src = fetchFromGitHub {
      owner = "fluxcd";
      repo = "notification-controller";
      rev = "v${version}";
      hash = "sha256-4m0/Nr9CoKN2ErccuGKyT/x6Mg9+qLyQEj9cCqWHtHc=";
    };

    vendorHash = "sha256-H4t1Sy+fnd+z6fUh3sIAeeSpbRE7VgeJxu1zvGxfV8M=";
    subPackages = [ "." ];
    
    env.CGO_ENABLED = 0;

    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };

in
mkImage {
  drv = flux-component;
  name = "flux-notification-controller";
  tag = "v${version}";
  entrypoint = [ "${flux-component}/bin/notification-controller" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert git ];

  labels = {
    "org.opencontainers.image.title" = "flux notification controller";
    "org.opencontainers.image.description" = "Flux GitOps flux-notification-controller";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "flux";
  };
}