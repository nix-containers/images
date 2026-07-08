{ nix2container, lib, pkgs, ... }:

# cass-config-builder — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/datastax/cass-config-builder:1.0.21
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "cass-config-builder";
  tag = "1.0.21";
  config.Labels = {
    "org.opencontainers.image.version" = "1.0.21";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/datastax/cass-config-builder:1.0.21 directly.";
    "io.nix-containers.upstream-image" = "docker.io/datastax/cass-config-builder:1.0.21";
    "io.nix-containers.image.upstream" = "docker.io/datastax/cass-config-builder";
  };
}
