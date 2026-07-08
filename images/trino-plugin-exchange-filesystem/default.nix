{ nix2container, lib, pkgs, ... }:

# trino-plugin-exchange-filesystem — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/trinodb/trino:482
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "trino-plugin-exchange-filesystem";
  tag = "482";
  config.Labels = {
    "org.opencontainers.image.version" = "482";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/trinodb/trino:482 directly.";
    "io.nix-containers.upstream-image" = "docker.io/trinodb/trino:482";
    "io.nix-containers.image.upstream" = "docker.io/trinodb/trino";
  };
}
