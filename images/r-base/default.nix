{ nix2container, lib, pkgs, ... }:

# r-base — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/library/r-base:4.6.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "r-base";
  tag = "4.6.1";
  config.Labels = {
    "org.opencontainers.image.version" = "4.6.1";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/library/r-base:4.6.1 directly.";
    "io.nix-containers.upstream-image" = "docker.io/library/r-base:4.6.1";
    "io.nix-containers.image.upstream" = "docker.io/library/r-base";
  };
}
