{ nix2container, lib, pkgs, ... }:

# management-api-for-apache-cassandra — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/k8ssandra/cass-management-api:4.0.20
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "management-api-for-apache-cassandra";
  tag = "4.0.20";
  config.Labels = {
    "org.opencontainers.image.version" = "4.0.20";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/k8ssandra/cass-management-api:4.0.20 directly.";
    "io.nix-containers.upstream-image" = "docker.io/k8ssandra/cass-management-api:4.0.20";
    "io.nix-containers.image.upstream" = "docker.io/k8ssandra/cass-management-api";
  };
}
