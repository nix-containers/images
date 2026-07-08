{ nix2container, lib, pkgs, ... }:

# wavefront-collector-for-kubernetes — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/wavefronthq/wavefront-kubernetes-collector:1.14.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "wavefront-collector-for-kubernetes";
  tag = "1.14.0";
  config.Labels = {
    "org.opencontainers.image.version" = "1.14.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/wavefronthq/wavefront-kubernetes-collector:1.14.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/wavefronthq/wavefront-kubernetes-collector:1.14.0";
    "io.nix-containers.image.upstream" = "docker.io/wavefronthq/wavefront-kubernetes-collector";
  };
}
