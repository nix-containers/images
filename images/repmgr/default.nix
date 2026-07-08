{ nix2container, lib, pkgs, ... }:

# repmgr — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/bitnamilegacy/postgresql-repmgr:17.6.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "repmgr";
  tag = "17.6.0";
  config.Labels = {
    "org.opencontainers.image.version" = "17.6.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/bitnamilegacy/postgresql-repmgr:17.6.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/bitnamilegacy/postgresql-repmgr:17.6.0";
    "io.nix-containers.image.upstream" = "docker.io/bitnamilegacy/postgresql-repmgr";
  };
}
