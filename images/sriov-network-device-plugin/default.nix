{ nix2container, lib, pkgs, ... }:

# sriov-network-device-plugin — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/k8snetworkplumbingwg/sriov-network-device-plugin:v3.6.2
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "sriov-network-device-plugin";
  tag = "v3.6.2";
  config.Labels = {
    "org.opencontainers.image.version" = "v3.6.2";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/k8snetworkplumbingwg/sriov-network-device-plugin:v3.6.2 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/k8snetworkplumbingwg/sriov-network-device-plugin:v3.6.2";
    "io.nix-containers.image.upstream" = "ghcr.io/k8snetworkplumbingwg/sriov-network-device-plugin";
  };
}
