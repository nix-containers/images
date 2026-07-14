{ nix2container, lib, pkgs, ... }:

# nrdot-collector-k8s-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/newrelic/nrdot-collector-k8s:1.12.0-fips
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "nrdot-collector-k8s-fips";
  tag = "1.12.0";
  config.Labels = {
    "org.opencontainers.image.version" = "1.12.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/newrelic/nrdot-collector-k8s:1.12.0-fips directly.";
    "io.nix-containers.upstream-image" = "docker.io/newrelic/nrdot-collector-k8s:1.12.0-fips";
    "io.nix-containers.image.upstream" = "docker.io/newrelic/nrdot-collector-k8s";
  };
}
