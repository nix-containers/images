{ nix2container, lib, pkgs, ... }:

# superset — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/apache/superset:4.1.4
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "superset";
  tag = "6.1.0";
  config.Labels = {
    "org.opencontainers.image.version" = "6.1.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/apache/superset:4.1.4 directly.";
    "io.nix-containers.upstream-image" = "docker.io/apache/superset:4.1.4";
    "io.nix-containers.image.upstream" = "docker.io/apache/superset";
  };
}
