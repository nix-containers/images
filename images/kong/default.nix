{ nix2container, lib, pkgs, ... }:

# kong — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/library/kong:3.9.3
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "kong";
  tag = "3.9.3";
  config.Labels = {
    "org.opencontainers.image.version" = "3.9.3";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/library/kong:3.9.3 directly.";
    "io.nix-containers.upstream-image" = "docker.io/library/kong:3.9.3";
    "io.nix-containers.image.upstream" = "docker.io/library/kong";
  };
}
