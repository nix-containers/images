{ nix2container, lib, pkgs, ... }:

# az-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: mcr.microsoft.com/azure-cli:2.88.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "az-fips";
  tag = "2.88.0";
  config.Labels = {
    "org.opencontainers.image.version" = "2.88.0";
    "org.opencontainers.image.description" = "Upstream reference — pull mcr.microsoft.com/azure-cli:2.88.0 directly.";
    "io.nix-containers.upstream-image" = "mcr.microsoft.com/azure-cli:2.88.0";
    "io.nix-containers.image.upstream" = "mcr.microsoft.com/azure-cli";
  };
}
