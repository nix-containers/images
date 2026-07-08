{ nix2container, lib, pkgs, ... }:

# aspnet-10-targeting-pack — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: mcr.microsoft.com/dotnet/sdk:10.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "aspnet-10-targeting-pack";
  tag = "10.0";
  config.Labels = {
    "org.opencontainers.image.version" = "10.0";
    "org.opencontainers.image.description" = "Upstream reference — pull mcr.microsoft.com/dotnet/sdk:10.0 directly.";
    "io.nix-containers.upstream-image" = "mcr.microsoft.com/dotnet/sdk:10.0";
    "io.nix-containers.image.upstream" = "mcr.microsoft.com/dotnet/sdk";
  };
}
