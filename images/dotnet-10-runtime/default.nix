{ nix2container, lib, pkgs, ... }:

# dotnet-10-runtime — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: mcr.microsoft.com/dotnet/runtime:10.0.9
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "dotnet-10-runtime";
  tag = "10.0.9";
  config.Labels = {
    "org.opencontainers.image.version" = "10.0.9";
    "org.opencontainers.image.description" = "Upstream reference — pull mcr.microsoft.com/dotnet/runtime:10.0.9 directly.";
    "io.nix-containers.upstream-image" = "mcr.microsoft.com/dotnet/runtime:10.0.9";
    "io.nix-containers.image.upstream" = "mcr.microsoft.com/dotnet/runtime";
  };
}
