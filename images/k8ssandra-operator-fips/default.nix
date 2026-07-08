{ nix2container, lib, pkgs, ... }:

# k8ssandra-operator-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/k8ssandra/k8ssandra-operator:v1.32.5
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "k8ssandra-operator-fips";
  tag = "v1.32.5";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.32.5";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/k8ssandra/k8ssandra-operator:v1.32.5 directly.";
    "io.nix-containers.upstream-image" = "docker.io/k8ssandra/k8ssandra-operator:v1.32.5";
    "io.nix-containers.image.upstream" = "docker.io/k8ssandra/k8ssandra-operator";
  };
}
