{ nix2container, lib, pkgs, ... }:

# dcgm-cuda — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/nvidia/dcgm:4.5.2-1-ubi9
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "dcgm-cuda";
  tag = "4.5.2-1-ubi9";
  config.Labels = {
    "org.opencontainers.image.version" = "4.5.2-1-ubi9";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/nvidia/dcgm:4.5.2-1-ubi9 directly.";
    "io.nix-containers.upstream-image" = "docker.io/nvidia/dcgm:4.5.2-1-ubi9";
    "io.nix-containers.image.upstream" = "docker.io/nvidia/dcgm";
  };
}
