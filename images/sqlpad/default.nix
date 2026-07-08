{ nix2container, lib, pkgs, ... }:

# sqlpad — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/sqlpad/sqlpad:7.5.7
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "sqlpad";
  tag = "7.5.7";
  config.Labels = {
    "org.opencontainers.image.version" = "7.5.7";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/sqlpad/sqlpad:7.5.7 directly.";
    "io.nix-containers.upstream-image" = "docker.io/sqlpad/sqlpad:7.5.7";
    "io.nix-containers.image.upstream" = "docker.io/sqlpad/sqlpad";
  };
}
