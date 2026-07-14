{ nix2container, lib, pkgs, ... }:

# pytorch-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/pytorch/pytorch:2.13.0-cuda12.6-cudnn9-runtime
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "pytorch-fips";
  tag = "0.2";
  config.Labels = {
    "org.opencontainers.image.version" = "0.2";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/pytorch/pytorch:2.13.0-cuda12.6-cudnn9-runtime directly.";
    "io.nix-containers.upstream-image" = "docker.io/pytorch/pytorch:2.13.0-cuda12.6-cudnn9-runtime";
    "io.nix-containers.image.upstream" = "docker.io/pytorch/pytorch";
  };
}
