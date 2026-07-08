{ nix2container, lib, pkgs, ... }:

# statsd — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/statsd/statsd:v0.10.2
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "statsd";
  tag = "v0.10.2";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.10.2";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/statsd/statsd:v0.10.2 directly.";
    "io.nix-containers.upstream-image" = "docker.io/statsd/statsd:v0.10.2";
    "io.nix-containers.image.upstream" = "docker.io/statsd/statsd";
  };
}
