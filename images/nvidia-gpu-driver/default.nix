{ nix2container, lib, pkgs, ... }:

# nvidia-gpu-driver — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/nvidia/driver:460.73.01-ubuntu20.04
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "nvidia-gpu-driver";
  tag = "460.73.01-ubuntu20.04";
  config.Labels = {
    "org.opencontainers.image.version" = "460.73.01-ubuntu20.04";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/nvidia/driver:460.73.01-ubuntu20.04 directly.";
    "io.nix-containers.upstream-image" = "docker.io/nvidia/driver:460.73.01-ubuntu20.04";
    "io.nix-containers.image.upstream" = "docker.io/nvidia/driver";
  };
}
