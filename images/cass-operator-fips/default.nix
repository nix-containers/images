{ nix2container, lib, pkgs, ... }:

# cass-operator-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/k8ssandra/cass-operator:v1.31.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "cass-operator-fips";
  tag = "v1.31.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.31.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/k8ssandra/cass-operator:v1.31.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/k8ssandra/cass-operator:v1.31.0";
    "io.nix-containers.image.upstream" = "docker.io/k8ssandra/cass-operator";
  };
}
