{ nix2container, lib, pkgs, ... }:

# quic-network-simulator — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/martenseemann/quic-network-simulator:latest
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "quic-network-simulator";
  tag = "latest";
  config.Labels = {
    "org.opencontainers.image.version" = "latest";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/martenseemann/quic-network-simulator:latest directly.";
    "io.nix-containers.upstream-image" = "docker.io/martenseemann/quic-network-simulator:latest";
    "io.nix-containers.image.upstream" = "docker.io/martenseemann/quic-network-simulator";
  };
}
