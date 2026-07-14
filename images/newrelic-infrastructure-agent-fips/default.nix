{ nix2container, lib, pkgs, ... }:

# newrelic-infrastructure-agent-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/newrelic/infrastructure:1.77.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "newrelic-infrastructure-agent-fips";
  tag = "1.78.0";
  config.Labels = {
    "org.opencontainers.image.version" = "1.78.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/newrelic/infrastructure:1.77.1 directly.";
    "io.nix-containers.upstream-image" = "docker.io/newrelic/infrastructure:1.77.1";
    "io.nix-containers.image.upstream" = "docker.io/newrelic/infrastructure";
  };
}
