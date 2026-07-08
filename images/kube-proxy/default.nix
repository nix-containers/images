{ mkImage, pkgs, lib, ... }:

# kube-proxy — Kubernetes control-plane component.
# Reworked from an (unbuildable) full-source scaffold to the nixpkgs binary:
# practical (no full kubernetes/kubernetes build), auto-updates via flake.lock.
mkImage {
  drv = pkgs.kubernetes;
  name = "kube-proxy";
  tag = "v${pkgs.kubernetes.version}";
  entrypoint = [ "${pkgs.kubernetes}/bin/kube-proxy" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.title" = "kube-proxy";
    "org.opencontainers.image.description" = "Kubernetes kube-proxy";
    "org.opencontainers.image.version" = pkgs.kubernetes.version;
    "io.nix-containers.chart" = "kubernetes";
  };
}
