{ nix2container, lib, pkgs, ... }:

# backing-image-manager — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/longhornio/backing-image-manager:v1.11.3
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "backing-image-manager";
  tag = "v1.11.3";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.11.3";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/longhornio/backing-image-manager:v1.11.3 directly.";
    "io.nix-containers.upstream-image" = "docker.io/longhornio/backing-image-manager:v1.11.3";
    "io.nix-containers.image.upstream" = "docker.io/longhornio/backing-image-manager";
  };
}
