{ mkImage, pkgs, lib, ... }:

# rke2-runtime - RKE2 (Rancher Kubernetes Engine 2) runtime binary
# https://github.com/rancher/rke2
#
# Uses pkgs.rke2 (built from source via buildGoModule in nixpkgs) instead of
# the upstream Rancher-published prebuilt binary; picks up current Go stdlib
# CVE fixes at each rebuild.
let
  drv = pkgs.rke2;
  version = drv.version;
in mkImage {
  inherit drv;
  name = "rke2-runtime";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/rke2" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "rke2-runtime";
    "org.opencontainers.image.description" = "RKE2 Kubernetes distribution runtime";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "nixpkgs";
  };
}
