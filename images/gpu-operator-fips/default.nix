{ nix2container, lib, pkgs, ... }:

# gpu-operator-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/nvidia/gpu-operator:v1.10.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "gpu-operator-fips";
  tag = "v1.10.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.10.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/nvidia/gpu-operator:v1.10.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/nvidia/gpu-operator:v1.10.0";
    "io.nix-containers.image.upstream" = "docker.io/nvidia/gpu-operator";
  };
}
