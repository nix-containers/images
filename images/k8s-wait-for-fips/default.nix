{ nix2container, lib, pkgs, ... }:

# k8s-wait-for-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/groundnuty/k8s-wait-for:v2.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "k8s-wait-for-fips";
  tag = "v2.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v2.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/groundnuty/k8s-wait-for:v2.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/groundnuty/k8s-wait-for:v2.0";
    "io.nix-containers.image.upstream" = "docker.io/groundnuty/k8s-wait-for";
  };
}
