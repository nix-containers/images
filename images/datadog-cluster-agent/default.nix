{ nix2container, lib, pkgs, ... }:

# datadog-cluster-agent — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/datadog/cluster-agent:7.81.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "datadog-cluster-agent";
  tag = "7.81.0";
  config.Labels = {
    "org.opencontainers.image.version" = "7.81.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/datadog/cluster-agent:7.81.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/datadog/cluster-agent:7.81.0";
    "io.nix-containers.image.upstream" = "docker.io/datadog/cluster-agent";
  };
}
