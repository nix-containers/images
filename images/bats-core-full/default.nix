{ nix2container, lib, pkgs, ... }:

# bats-core-full — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/bats/bats:1.13.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "bats-core-full";
  tag = "1.13.0";
  config.Labels = {
    "org.opencontainers.image.version" = "1.13.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/bats/bats:1.13.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/bats/bats:1.13.0";
    "io.nix-containers.image.upstream" = "docker.io/bats/bats";
  };
}
