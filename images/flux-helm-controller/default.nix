{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# flux-helm-controller
# Flux GitOps component

let
  version = "1.6.2";
  flux-component = buildGoModule {
    pname = "flux-helm-controller";
    inherit version;

    src = fetchFromGitHub {
      owner = "fluxcd";
      repo = "helm-controller";
      rev = "v${version}";
      hash = "sha256-w8SZjfpV8O4RWun7lq0Z+b8ZyGQxeTv34QTnY0lIEQ4=";
    };

    vendorHash = "sha256-KfG7NpxpXjajtPdbDoxZpilASRyyJszv249xZj5znVE=";
    subPackages = [ "." ];
    
    env.CGO_ENABLED = 0;
    env.GOTOOLCHAIN = "local";

    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };

in
mkImage {
  drv = flux-component;
  name = "flux-helm-controller";
  tag = "v${version}";
  entrypoint = [ "${flux-component}/bin/helm-controller" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert git ];

  labels = {
    "org.opencontainers.image.title" = "flux helm controller";
    "org.opencontainers.image.description" = "Flux GitOps flux-helm-controller";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "flux";
  };
}