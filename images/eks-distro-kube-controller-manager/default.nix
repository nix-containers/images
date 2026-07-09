{ mkImage, pkgs, lib, ... }:

# EKS Distro kube-controller-manager — built from source via pkgs.kubernetes.
# https://kubernetes.io
let
  drv = pkgs.kubernetes;
  version = drv.version;
in mkImage {
  inherit drv;
  name = "eks-distro-kube-controller-manager";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/kube-controller-manager" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "eks-distro-kube-controller-manager";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "nixpkgs";
  };
}
