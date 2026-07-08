{ nix2container, lib, pkgs, ... }:

# datadog-cluster-agent-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/datadog/cluster-agent:7.81.0-fips
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "datadog-cluster-agent-fips";
  tag = "7.81.0-fips";
  config.Labels = {
    "org.opencontainers.image.version" = "7.81.0-fips";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/datadog/cluster-agent:7.81.0-fips directly.";
    "io.nix-containers.upstream-image" = "docker.io/datadog/cluster-agent:7.81.0-fips";
    "io.nix-containers.image.upstream" = "docker.io/datadog/cluster-agent";
  };
}
