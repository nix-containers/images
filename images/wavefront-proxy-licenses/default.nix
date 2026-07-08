{ nix2container, lib, pkgs, ... }:

# wavefront-proxy-licenses — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/wavefronthq/proxy:13.7
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "wavefront-proxy-licenses";
  tag = "13.7";
  config.Labels = {
    "org.opencontainers.image.version" = "13.7";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/wavefronthq/proxy:13.7 directly.";
    "io.nix-containers.upstream-image" = "docker.io/wavefronthq/proxy:13.7";
    "io.nix-containers.image.upstream" = "docker.io/wavefronthq/proxy";
  };
}
