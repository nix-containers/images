{ nix2container, lib, pkgs, ... }:

# newrelic-fluent-bit-output — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/newrelic/newrelic-fluentbit-output:3.7.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "newrelic-fluent-bit-output";
  tag = "3.7.0";
  config.Labels = {
    "org.opencontainers.image.version" = "3.7.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/newrelic/newrelic-fluentbit-output:3.7.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/newrelic/newrelic-fluentbit-output:3.7.0";
    "io.nix-containers.image.upstream" = "docker.io/newrelic/newrelic-fluentbit-output";
  };
}
