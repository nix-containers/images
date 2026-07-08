{ nix2container, lib, pkgs, ... }:

# gpu-feature-discovery-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/nvidia/gpu-feature-discovery:v0.5.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "gpu-feature-discovery-fips";
  tag = "v0.5.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.5.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/nvidia/gpu-feature-discovery:v0.5.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/nvidia/gpu-feature-discovery:v0.5.0";
    "io.nix-containers.image.upstream" = "docker.io/nvidia/gpu-feature-discovery";
  };
}
