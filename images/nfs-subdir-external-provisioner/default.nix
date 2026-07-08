{ nix2container, lib, pkgs, ... }:

# nfs-subdir-external-provisioner — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: registry.k8s.io/sig-storage/nfs-subdir-external-provisioner:v4.0.2
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "nfs-subdir-external-provisioner";
  tag = "v4.0.2";
  config.Labels = {
    "org.opencontainers.image.version" = "v4.0.2";
    "org.opencontainers.image.description" = "Upstream reference — pull registry.k8s.io/sig-storage/nfs-subdir-external-provisioner:v4.0.2 directly.";
    "io.nix-containers.upstream-image" = "registry.k8s.io/sig-storage/nfs-subdir-external-provisioner:v4.0.2";
    "io.nix-containers.image.upstream" = "registry.k8s.io/sig-storage/nfs-subdir-external-provisioner";
  };
}
