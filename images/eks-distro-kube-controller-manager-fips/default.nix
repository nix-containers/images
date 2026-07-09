{ mkImage, pkgs, lib, ... }:

# EKS Distro kube-controller-manager — -fips variant packages the same
# upstream binary (no FIPS claim made). Built from source via pkgs.kubernetes.
# https://kubernetes.io
let
  drv = pkgs.kubernetes;
  version = drv.version;
in mkImage {
  inherit drv;
  name = "eks-distro-kube-controller-manager-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/kube-controller-manager" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "eks-distro-kube-controller-manager-fips";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "nixpkgs";
  };
}
