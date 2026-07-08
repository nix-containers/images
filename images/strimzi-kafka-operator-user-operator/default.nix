{ nix2container, lib, pkgs, ... }:

# strimzi-kafka-operator-user-operator — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: quay.io/strimzi/operator:1.0.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "strimzi-kafka-operator-user-operator";
  tag = "1.0.1";
  config.Labels = {
    "org.opencontainers.image.version" = "1.0.1";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/strimzi/operator:1.0.1 directly.";
    "io.nix-containers.upstream-image" = "quay.io/strimzi/operator:1.0.1";
    "io.nix-containers.image.upstream" = "quay.io/strimzi/operator";
  };
}
