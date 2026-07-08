{ nix2container, lib, pkgs, ... }:

# livekit-egress — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/livekit/egress:v1.13.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "livekit-egress";
  tag = "v1.13.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.13.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/livekit/egress:v1.13.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/livekit/egress:v1.13.0";
    "io.nix-containers.image.upstream" = "docker.io/livekit/egress";
  };
}
