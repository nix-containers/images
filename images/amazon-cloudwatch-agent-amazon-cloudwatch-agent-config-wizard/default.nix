{ nix2container, lib, pkgs, ... }:

# amazon-cloudwatch-agent-amazon-cloudwatch-agent-config-wizard — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/amazon/cloudwatch-agent:1.300069.0b1529
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "amazon-cloudwatch-agent-amazon-cloudwatch-agent-config-wizard";
  tag = "1.300069.0b1529";
  config.Labels = {
    "org.opencontainers.image.version" = "1.300069.0b1529";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/amazon/cloudwatch-agent:1.300069.0b1529 directly.";
    "io.nix-containers.upstream-image" = "docker.io/amazon/cloudwatch-agent:1.300069.0b1529";
    "io.nix-containers.image.upstream" = "docker.io/amazon/cloudwatch-agent";
  };
}
