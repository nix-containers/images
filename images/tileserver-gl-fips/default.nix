{ nix2container, lib, pkgs, ... }:

# tileserver-gl-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/maptiler/tileserver-gl:v5.6.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "tileserver-gl-fips";
  tag = "v5.6.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v5.6.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/maptiler/tileserver-gl:v5.6.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/maptiler/tileserver-gl:v5.6.0";
    "io.nix-containers.image.upstream" = "docker.io/maptiler/tileserver-gl";
  };
}
