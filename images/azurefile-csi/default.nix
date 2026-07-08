{ nix2container, lib, pkgs, ... }:

# azurefile-csi — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: mcr.microsoft.com/oss/kubernetes-csi/azurefile-csi:v1.33.3
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "azurefile-csi";
  tag = "v1.33.3";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.33.3";
    "org.opencontainers.image.description" = "Upstream reference — pull mcr.microsoft.com/oss/kubernetes-csi/azurefile-csi:v1.33.3 directly.";
    "io.nix-containers.upstream-image" = "mcr.microsoft.com/oss/kubernetes-csi/azurefile-csi:v1.33.3";
    "io.nix-containers.image.upstream" = "mcr.microsoft.com/oss/kubernetes-csi/azurefile-csi";
  };
}
