{ mkImage, pkgs, lib, ... }:

# kubectl — Kubernetes component from the nixpkgs binary (auto-updates via flake.lock).
mkImage {
  drv = pkgs.kubernetes;
  name = "kubectl";
  tag = "v${pkgs.kubernetes.version}";
  entrypoint = [ "${pkgs.kubernetes}/bin/kubectl" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.title" = "kubectl";
    "org.opencontainers.image.description" = "Kubernetes kubectl";
    "org.opencontainers.image.version" = pkgs.kubernetes.version;
    "io.nix-containers.chart" = "kubernetes";
  };
}
