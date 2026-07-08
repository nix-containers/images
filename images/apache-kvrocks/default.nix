{ nix2container, lib, pkgs, ... }:

# apache-kvrocks — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/apache/kvrocks:2.16.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "apache-kvrocks";
  tag = "2.16.0";
  config.Labels = {
    "org.opencontainers.image.version" = "2.16.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/apache/kvrocks:2.16.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/apache/kvrocks:2.16.0";
    "io.nix-containers.image.upstream" = "docker.io/apache/kvrocks";
  };
}
