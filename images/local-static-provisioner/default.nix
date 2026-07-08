{ nix2container, lib, pkgs, ... }:

# local-static-provisioner — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: registry.k8s.io/sig-storage/local-volume-provisioner:v2.8.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "local-static-provisioner";
  tag = "v2.8.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v2.8.0";
    "org.opencontainers.image.description" = "Upstream reference — pull registry.k8s.io/sig-storage/local-volume-provisioner:v2.8.0 directly.";
    "io.nix-containers.upstream-image" = "registry.k8s.io/sig-storage/local-volume-provisioner:v2.8.0";
    "io.nix-containers.image.upstream" = "registry.k8s.io/sig-storage/local-volume-provisioner";
  };
}
