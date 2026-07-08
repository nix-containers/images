{ nix2container, lib, pkgs, ... }:

# dogstatsd — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/datadog/dogstatsd:7.80.4
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "dogstatsd";
  tag = "7.80.4";
  config.Labels = {
    "org.opencontainers.image.version" = "7.80.4";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/datadog/dogstatsd:7.80.4 directly.";
    "io.nix-containers.upstream-image" = "docker.io/datadog/dogstatsd:7.80.4";
    "io.nix-containers.image.upstream" = "docker.io/datadog/dogstatsd";
  };
}
