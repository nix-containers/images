{ nix2container, lib, pkgs, ... }:

# newrelic-prometheus-configurator — UPSTREAM REFERENCE (not built/hosted). Use docker.io/newrelic/newrelic-prometheus-configurator:2.12.0 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "newrelic-prometheus-configurator";
  tag = "2.12.0";
  config.Labels = {
    "org.opencontainers.image.version" = "2.12.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/newrelic/newrelic-prometheus-configurator:2.12.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/newrelic/newrelic-prometheus-configurator:2.12.0";
    "io.nix-containers.image.upstream" = "docker.io/newrelic/newrelic-prometheus-configurator";
  };
}
