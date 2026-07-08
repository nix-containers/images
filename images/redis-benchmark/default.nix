{ nix2container, lib, pkgs, ... }:

# redis-benchmark — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/library/redis:8.8.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "redis-benchmark";
  tag = "8.8.0";
  config.Labels = {
    "org.opencontainers.image.version" = "8.8.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/library/redis:8.8.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/library/redis:8.8.0";
    "io.nix-containers.image.upstream" = "docker.io/library/redis";
  };
}
