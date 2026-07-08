{ nix2container, lib, pkgs, ... }:

# cassandra-medusa-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/k8ssandra/medusa:0.29.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "cassandra-medusa-fips";
  tag = "0.29.1";
  config.Labels = {
    "org.opencontainers.image.version" = "0.29.1";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/k8ssandra/medusa:0.29.1 directly.";
    "io.nix-containers.upstream-image" = "docker.io/k8ssandra/medusa:0.29.1";
    "io.nix-containers.image.upstream" = "docker.io/k8ssandra/medusa";
  };
}
