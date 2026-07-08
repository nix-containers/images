{ nix2container, lib, pkgs, ... }:

# azure-functions-host — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: mcr.microsoft.com/azure-functions/base:4.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "azure-functions-host";
  tag = "4.0";
  config.Labels = {
    "org.opencontainers.image.version" = "4.0";
    "org.opencontainers.image.description" = "Upstream reference — pull mcr.microsoft.com/azure-functions/base:4.0 directly.";
    "io.nix-containers.upstream-image" = "mcr.microsoft.com/azure-functions/base:4.0";
    "io.nix-containers.image.upstream" = "mcr.microsoft.com/azure-functions/base";
  };
}
