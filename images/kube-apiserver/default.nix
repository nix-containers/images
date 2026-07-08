{ mkImage, pkgs, lib, ... }:

# kube-apiserver — Kubernetes control-plane component.
# Reworked from an (unbuildable) full-source scaffold to the nixpkgs binary:
# practical (no full kubernetes/kubernetes build), auto-updates via flake.lock.
mkImage {
  drv = pkgs.kubernetes;
  name = "kube-apiserver";
  tag = "v${pkgs.kubernetes.version}";
  entrypoint = [ "${pkgs.kubernetes}/bin/kube-apiserver" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.title" = "kube-apiserver";
    "org.opencontainers.image.description" = "Kubernetes kube-apiserver";
    "org.opencontainers.image.version" = pkgs.kubernetes.version;
    "io.nix-containers.chart" = "kubernetes";
  };
}
