{ nix2container, lib, pkgs, ... }:

# newrelic-nri-statsd — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/newrelic/nri-statsd:2.15.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "newrelic-nri-statsd";
  tag = "2.15.0";
  config.Labels = {
    "org.opencontainers.image.version" = "2.15.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/newrelic/nri-statsd:2.15.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/newrelic/nri-statsd:2.15.0";
    "io.nix-containers.image.upstream" = "docker.io/newrelic/nri-statsd";
  };
}
