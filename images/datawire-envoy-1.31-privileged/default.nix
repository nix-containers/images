{ nix2container, lib, pkgs, ... }:

# datawire-envoy-1.31-privileged — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/envoyproxy/envoy:v1.31.5
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "datawire-envoy-1.31-privileged";
  tag = "v1.31.5";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.31.5";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/envoyproxy/envoy:v1.31.5 directly.";
    "io.nix-containers.upstream-image" = "docker.io/envoyproxy/envoy:v1.31.5";
    "io.nix-containers.image.upstream" = "docker.io/envoyproxy/envoy";
  };
}
