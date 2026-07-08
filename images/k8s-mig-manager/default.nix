{ nix2container, lib, pkgs, ... }:

# k8s-mig-manager — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/nvidia/k8s-mig-manager:v0.4.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "k8s-mig-manager";
  tag = "v0.4.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.4.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/nvidia/k8s-mig-manager:v0.4.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/nvidia/k8s-mig-manager:v0.4.0";
    "io.nix-containers.image.upstream" = "docker.io/nvidia/k8s-mig-manager";
  };
}
