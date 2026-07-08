{ nix2container, lib, pkgs, ... }:

# klipper-helm — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/rancher/klipper-helm:v0.12.0-build20260625
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "klipper-helm";
  tag = "v0.12.0-build20260625";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.12.0-build20260625";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/rancher/klipper-helm:v0.12.0-build20260625 directly.";
    "io.nix-containers.upstream-image" = "docker.io/rancher/klipper-helm:v0.12.0-build20260625";
    "io.nix-containers.image.upstream" = "docker.io/rancher/klipper-helm";
  };
}
