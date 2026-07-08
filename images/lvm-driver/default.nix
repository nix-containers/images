{ nix2container, lib, pkgs, ... }:

# lvm-driver — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/openebs/lvm-driver:1.9.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "lvm-driver";
  tag = "1.9.1";
  config.Labels = {
    "org.opencontainers.image.version" = "1.9.1";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/openebs/lvm-driver:1.9.1 directly.";
    "io.nix-containers.upstream-image" = "docker.io/openebs/lvm-driver:1.9.1";
    "io.nix-containers.image.upstream" = "docker.io/openebs/lvm-driver";
  };
}
