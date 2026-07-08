{ nix2container, lib, pkgs, ... }:

# datadog-operator — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/datadog/operator:1.28.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "datadog-operator";
  tag = "1.28.0";
  config.Labels = {
    "org.opencontainers.image.version" = "1.28.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/datadog/operator:1.28.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/datadog/operator:1.28.0";
    "io.nix-containers.image.upstream" = "docker.io/datadog/operator";
  };
}
