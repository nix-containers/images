{ nix2container, lib, pkgs, ... }:

# dotnet-10-sdk — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: mcr.microsoft.com/dotnet/sdk:10.0.301
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "dotnet-10-sdk";
  tag = "10.0.301";
  config.Labels = {
    "org.opencontainers.image.version" = "10.0.301";
    "org.opencontainers.image.description" = "Upstream reference — pull mcr.microsoft.com/dotnet/sdk:10.0.301 directly.";
    "io.nix-containers.upstream-image" = "mcr.microsoft.com/dotnet/sdk:10.0.301";
    "io.nix-containers.image.upstream" = "mcr.microsoft.com/dotnet/sdk";
  };
}
