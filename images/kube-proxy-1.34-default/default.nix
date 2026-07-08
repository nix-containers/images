{ mkImage, pkgs, lib, ... }:

# kube-proxy-1.34-default — Kubernetes component from the nixpkgs binary (auto-updates via flake.lock).
mkImage {
  drv = pkgs.kubernetes;
  name = "kube-proxy-1.34-default";
  tag = "v${pkgs.kubernetes.version}";
  entrypoint = [ "${pkgs.kubernetes}/bin/kube-proxy" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.title" = "kube-proxy-1.34-default";
    "org.opencontainers.image.description" = "Kubernetes kube-proxy";
    "org.opencontainers.image.version" = pkgs.kubernetes.version;
    "io.nix-containers.chart" = "kubernetes";
  };
}
