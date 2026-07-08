{ nix2container, lib, pkgs, ... }:

# k8ssandra-system-logger-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/k8ssandra/system-logger:v1.30.3
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "k8ssandra-system-logger-fips";
  tag = "v1.30.3";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.30.3";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/k8ssandra/system-logger:v1.30.3 directly.";
    "io.nix-containers.upstream-image" = "docker.io/k8ssandra/system-logger:v1.30.3";
    "io.nix-containers.image.upstream" = "docker.io/k8ssandra/system-logger";
  };
}
