{ nix2container, lib, pkgs, ... }:

# nextcloud-server — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/library/nextcloud:34.0.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "nextcloud-server";
  tag = "34.0.1";
  config.Labels = {
    "org.opencontainers.image.version" = "34.0.1";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/library/nextcloud:34.0.1 directly.";
    "io.nix-containers.upstream-image" = "docker.io/library/nextcloud:34.0.1";
    "io.nix-containers.image.upstream" = "docker.io/library/nextcloud";
  };
}
