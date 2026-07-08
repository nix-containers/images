{ mkImage, pkgs, lib, ... }:

# kube-scheduler — Kubernetes control-plane component.
# Reworked from an (unbuildable) full-source scaffold to the nixpkgs binary:
# practical (no full kubernetes/kubernetes build), auto-updates via flake.lock.
mkImage {
  drv = pkgs.kubernetes;
  name = "kube-scheduler";
  tag = "v${pkgs.kubernetes.version}";
  entrypoint = [ "${pkgs.kubernetes}/bin/kube-scheduler" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.title" = "kube-scheduler";
    "org.opencontainers.image.description" = "Kubernetes kube-scheduler";
    "org.opencontainers.image.version" = pkgs.kubernetes.version;
    "io.nix-containers.chart" = "kubernetes";
  };
}
