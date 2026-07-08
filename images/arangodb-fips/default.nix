{ nix2container, lib, pkgs, ... }:

# arangodb-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/library/arangodb:3.12.9
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "arangodb-fips";
  tag = "3.12.9";
  config.Labels = {
    "org.opencontainers.image.version" = "3.12.9";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/library/arangodb:3.12.9 directly.";
    "io.nix-containers.upstream-image" = "docker.io/library/arangodb:3.12.9";
    "io.nix-containers.image.upstream" = "docker.io/library/arangodb";
  };
}
