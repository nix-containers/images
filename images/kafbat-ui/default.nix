{ nix2container, lib, pkgs, ... }:

# kafbat-ui — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/kafbat/kafka-ui:v1.5.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "kafbat-ui";
  tag = "v1.5.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.5.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/kafbat/kafka-ui:v1.5.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/kafbat/kafka-ui:v1.5.0";
    "io.nix-containers.image.upstream" = "docker.io/kafbat/kafka-ui";
  };
}
