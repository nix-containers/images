{ nix2container, lib, pkgs, ... }:

# grafana-rollout-operator-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/grafana/rollout-operator:v0.38.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "grafana-rollout-operator-fips";
  tag = "v0.38.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.38.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/grafana/rollout-operator:v0.38.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/grafana/rollout-operator:v0.38.0";
    "io.nix-containers.image.upstream" = "docker.io/grafana/rollout-operator";
  };
}
