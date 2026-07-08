{ nix2container, lib, pkgs, ... }:

# secrets-store-csi-driver-provider-azure — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: mcr.microsoft.com/oss/azure/secrets-store/provider-azure:v1.6.2
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "secrets-store-csi-driver-provider-azure";
  tag = "v1.6.2";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.6.2";
    "org.opencontainers.image.description" = "Upstream reference — pull mcr.microsoft.com/oss/azure/secrets-store/provider-azure:v1.6.2 directly.";
    "io.nix-containers.upstream-image" = "mcr.microsoft.com/oss/azure/secrets-store/provider-azure:v1.6.2";
    "io.nix-containers.image.upstream" = "mcr.microsoft.com/oss/azure/secrets-store/provider-azure";
  };
}
