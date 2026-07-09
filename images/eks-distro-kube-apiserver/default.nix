{ mkImage, pkgs, lib, ... }:

# EKS Distro kube-apiserver — the upstream Kubernetes API server.
# https://kubernetes.io
#
# Uses pkgs.kubernetes (built from source via buildGoModule in nixpkgs), so
# every rebuild picks up current Go stdlib CVE fixes and the latest nixpkgs
# k8s release. Previously pinned to 1.31.14 via a `dl.k8s.io` prebuilt
# binary, which froze the Go stdlib.
let
  drv = pkgs.kubernetes;
  version = drv.version;
in mkImage {
  inherit drv;
  name = "eks-distro-kube-apiserver";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/kube-apiserver" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "eks-distro-kube-apiserver";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "nixpkgs";
  };
}
