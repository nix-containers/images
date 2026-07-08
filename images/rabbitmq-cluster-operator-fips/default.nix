{ nix2container, lib, pkgs, ... }:

# rabbitmq-cluster-operator-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/rabbitmqoperator/cluster-operator:2.19.2
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "rabbitmq-cluster-operator-fips";
  tag = "2.19.2";
  config.Labels = {
    "org.opencontainers.image.version" = "2.19.2";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/rabbitmqoperator/cluster-operator:2.19.2 directly.";
    "io.nix-containers.upstream-image" = "docker.io/rabbitmqoperator/cluster-operator:2.19.2";
    "io.nix-containers.image.upstream" = "docker.io/rabbitmqoperator/cluster-operator";
  };
}
