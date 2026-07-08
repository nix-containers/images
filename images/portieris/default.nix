{ nix2container, lib, pkgs, ... }:

# portieris — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: icr.io/portieris/portieris:v0.13.32
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "portieris";
  tag = "v0.13.32";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.13.32";
    "org.opencontainers.image.description" = "Upstream reference — pull icr.io/portieris/portieris:v0.13.32 directly.";
    "io.nix-containers.upstream-image" = "icr.io/portieris/portieris:v0.13.32";
    "io.nix-containers.image.upstream" = "icr.io/portieris/portieris";
  };
}
