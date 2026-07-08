{ nix2container, lib, pkgs, ... }:

# debezium-connect — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/debezium/connect:2.7.3.Final
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "debezium-connect";
  tag = "2.7.3.Final";
  config.Labels = {
    "org.opencontainers.image.version" = "2.7.3.Final";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/debezium/connect:2.7.3.Final directly.";
    "io.nix-containers.upstream-image" = "docker.io/debezium/connect:2.7.3.Final";
    "io.nix-containers.image.upstream" = "docker.io/debezium/connect";
  };
}
