{ nix2container, lib, pkgs, ... }:

# strimzi-kafka-operator-kafka-agent — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: quay.io/strimzi/kafka:0.47.0-kafka-4.0.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "strimzi-kafka-operator-kafka-agent";
  tag = "0.47.0-kafka-4.0.0";
  config.Labels = {
    "org.opencontainers.image.version" = "0.47.0-kafka-4.0.0";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/strimzi/kafka:0.47.0-kafka-4.0.0 directly.";
    "io.nix-containers.upstream-image" = "quay.io/strimzi/kafka:0.47.0-kafka-4.0.0";
    "io.nix-containers.image.upstream" = "quay.io/strimzi/kafka";
  };
}
