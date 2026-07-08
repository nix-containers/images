{ nix2container, lib, pkgs, ... }:

# vela-core — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/oamdev/vela-core:v1.10.9
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "vela-core";
  tag = "v1.10.9";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.10.9";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/oamdev/vela-core:v1.10.9 directly.";
    "io.nix-containers.upstream-image" = "docker.io/oamdev/vela-core:v1.10.9";
    "io.nix-containers.image.upstream" = "docker.io/oamdev/vela-core";
  };
}
