{ mkImage, pkgs, lib, ... }:

# EKS Distro kube-apiserver — -fips variant packages the same upstream
# binary (no FIPS claim made). Built from source via pkgs.kubernetes.
# https://kubernetes.io
let
  drv = pkgs.kubernetes;
  version = drv.version;
in mkImage {
  inherit drv;
  name = "eks-distro-kube-apiserver-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/kube-apiserver" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "eks-distro-kube-apiserver-fips";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "nixpkgs";
  };
}
