{ nix2container, lib, pkgs, ... }:

# datadog-operator-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/datadog/operator:1.28.0-fips
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "datadog-operator-fips";
  tag = "1.28.0-fips";
  config.Labels = {
    "org.opencontainers.image.version" = "1.28.0-fips";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/datadog/operator:1.28.0-fips directly.";
    "io.nix-containers.upstream-image" = "docker.io/datadog/operator:1.28.0-fips";
    "io.nix-containers.image.upstream" = "docker.io/datadog/operator";
  };
}
