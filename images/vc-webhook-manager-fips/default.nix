{ nix2container, lib, pkgs, ... }:

# vc-webhook-manager-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/volcanosh/vc-webhook-manager:v1.14.3
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "vc-webhook-manager-fips";
  tag = "v1.14.3";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.14.3";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/volcanosh/vc-webhook-manager:v1.14.3 directly.";
    "io.nix-containers.upstream-image" = "docker.io/volcanosh/vc-webhook-manager:v1.14.3";
    "io.nix-containers.image.upstream" = "docker.io/volcanosh/vc-webhook-manager";
  };
}
