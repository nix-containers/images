{ nix2container, lib, pkgs, ... }:

# azure-functions-python-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: mcr.microsoft.com/azure-functions/python:4-python3.11
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "azure-functions-python-fips";
  tag = "4-python3.11";
  config.Labels = {
    "org.opencontainers.image.version" = "4-python3.11";
    "org.opencontainers.image.description" = "Upstream reference — pull mcr.microsoft.com/azure-functions/python:4-python3.11 directly.";
    "io.nix-containers.upstream-image" = "mcr.microsoft.com/azure-functions/python:4-python3.11";
    "io.nix-containers.image.upstream" = "mcr.microsoft.com/azure-functions/python";
  };
}
