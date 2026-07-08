{ mkImage, pkgs, lib, ... }:

# kube-scheduler-1.34-default — Kubernetes component from the nixpkgs binary (auto-updates via flake.lock).
mkImage {
  drv = pkgs.kubernetes;
  name = "kube-scheduler-1.34-default";
  tag = "v${pkgs.kubernetes.version}";
  entrypoint = [ "${pkgs.kubernetes}/bin/kube-scheduler" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.title" = "kube-scheduler-1.34-default";
    "org.opencontainers.image.description" = "Kubernetes kube-scheduler";
    "org.opencontainers.image.version" = pkgs.kubernetes.version;
    "io.nix-containers.chart" = "kubernetes";
  };
}
