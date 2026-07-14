{ nix2container, lib, pkgs, ... }:

# rabbitmq-messaging-topology-operator — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/rabbitmqoperator/messaging-topology-operator:1.19.3
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "rabbitmq-messaging-topology-operator";
  tag = "1.20.0";
  config.Labels = {
    "org.opencontainers.image.version" = "1.20.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/rabbitmqoperator/messaging-topology-operator:1.19.3 directly.";
    "io.nix-containers.upstream-image" = "docker.io/rabbitmqoperator/messaging-topology-operator:1.19.3";
    "io.nix-containers.image.upstream" = "docker.io/rabbitmqoperator/messaging-topology-operator";
  };
}
