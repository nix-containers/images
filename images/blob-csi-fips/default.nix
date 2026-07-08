{ nix2container, lib, pkgs, ... }:

# blob-csi-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: mcr.microsoft.com/oss/kubernetes-csi/blob-csi:v1.9.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "blob-csi-fips";
  tag = "v1.9.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.9.0";
    "org.opencontainers.image.description" = "Upstream reference — pull mcr.microsoft.com/oss/kubernetes-csi/blob-csi:v1.9.0 directly.";
    "io.nix-containers.upstream-image" = "mcr.microsoft.com/oss/kubernetes-csi/blob-csi:v1.9.0";
    "io.nix-containers.image.upstream" = "mcr.microsoft.com/oss/kubernetes-csi/blob-csi";
  };
}
