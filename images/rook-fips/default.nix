{ nix2container, lib, pkgs, ... }:

# rook-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/rook/ceph:v1.20.2
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "rook-fips";
  tag = "v1.20.2";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.20.2";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/rook/ceph:v1.20.2 directly.";
    "io.nix-containers.upstream-image" = "docker.io/rook/ceph:v1.20.2";
    "io.nix-containers.image.upstream" = "docker.io/rook/ceph";
  };
}
