{ nix2container, lib, pkgs, ... }:

# rke2-cloud-provider — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/rancher/rke2-cloud-provider:v1.36.1-0.20260508014929-7bbbf7c9b258-build20260515
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "rke2-cloud-provider";
  tag = "v1.36.1-0.20260508014929-7bbbf7c9b258-build20260515";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.36.1-0.20260508014929-7bbbf7c9b258-build20260515";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/rancher/rke2-cloud-provider:v1.36.1-0.20260508014929-7bbbf7c9b258-build20260515 directly.";
    "io.nix-containers.upstream-image" = "docker.io/rancher/rke2-cloud-provider:v1.36.1-0.20260508014929-7bbbf7c9b258-build20260515";
    "io.nix-containers.image.upstream" = "docker.io/rancher/rke2-cloud-provider";
  };
}
