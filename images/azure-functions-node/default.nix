{ nix2container, lib, pkgs, ... }:

# azure-functions-node — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: mcr.microsoft.com/azure-functions/node:4-node20
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "azure-functions-node";
  tag = "4-node20";
  config.Labels = {
    "org.opencontainers.image.version" = "4-node20";
    "org.opencontainers.image.description" = "Upstream reference — pull mcr.microsoft.com/azure-functions/node:4-node20 directly.";
    "io.nix-containers.upstream-image" = "mcr.microsoft.com/azure-functions/node:4-node20";
    "io.nix-containers.image.upstream" = "mcr.microsoft.com/azure-functions/node";
  };
}
