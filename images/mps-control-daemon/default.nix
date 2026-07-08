{ nix2container, lib, pkgs, ... }:

# mps-control-daemon — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/nvidia/k8s-device-plugin:v0.5.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "mps-control-daemon";
  tag = "v0.5.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.5.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/nvidia/k8s-device-plugin:v0.5.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/nvidia/k8s-device-plugin:v0.5.0";
    "io.nix-containers.image.upstream" = "docker.io/nvidia/k8s-device-plugin";
  };
}
