{ nix2container, lib, pkgs, ... }:

# kserve-rest-proxy — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/kserve/rest-proxy:v0.12.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "kserve-rest-proxy";
  tag = "v0.12.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.12.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/kserve/rest-proxy:v0.12.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/kserve/rest-proxy:v0.12.0";
    "io.nix-containers.image.upstream" = "docker.io/kserve/rest-proxy";
  };
}
