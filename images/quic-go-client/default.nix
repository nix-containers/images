{ nix2container, lib, pkgs, ... }:

# quic-go-client — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/martenseemann/quic-go-interop:v0.60.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "quic-go-client";
  tag = "v0.60.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.60.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/martenseemann/quic-go-interop:v0.60.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/martenseemann/quic-go-interop:v0.60.0";
    "io.nix-containers.image.upstream" = "docker.io/martenseemann/quic-go-interop";
  };
}
