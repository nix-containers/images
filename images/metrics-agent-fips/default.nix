{ nix2container, lib, pkgs, ... }:

# metrics-agent-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/cloudability/metrics-agent:2.14.14
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "metrics-agent-fips";
  tag = "2.14.14";
  config.Labels = {
    "org.opencontainers.image.version" = "2.14.14";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/cloudability/metrics-agent:2.14.14 directly.";
    "io.nix-containers.upstream-image" = "docker.io/cloudability/metrics-agent:2.14.14";
    "io.nix-containers.image.upstream" = "docker.io/cloudability/metrics-agent";
  };
}
