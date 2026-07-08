{ nix2container, lib, pkgs, ... }:

# rke2-runtime-airgap — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/rancher/rke2-runtime:v1.36.2-rke2r1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "rke2-runtime-airgap";
  tag = "v1.36.2-rke2r1";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.36.2-rke2r1";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/rancher/rke2-runtime:v1.36.2-rke2r1 directly.";
    "io.nix-containers.upstream-image" = "docker.io/rancher/rke2-runtime:v1.36.2-rke2r1";
    "io.nix-containers.image.upstream" = "docker.io/rancher/rke2-runtime";
  };
}
