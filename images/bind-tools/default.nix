{ nix2container, lib, pkgs, ... }:

# bind-tools — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/internetsystemsconsortium/bind9:9.20
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "bind-tools";
  tag = "9.20";
  config.Labels = {
    "org.opencontainers.image.version" = "9.20";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/internetsystemsconsortium/bind9:9.20 directly.";
    "io.nix-containers.upstream-image" = "docker.io/internetsystemsconsortium/bind9:9.20";
    "io.nix-containers.image.upstream" = "docker.io/internetsystemsconsortium/bind9";
  };
}
