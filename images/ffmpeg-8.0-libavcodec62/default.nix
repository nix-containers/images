{ nix2container, lib, pkgs, ... }:

# ffmpeg-8.0-libavcodec62 — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/jrottenberg/ffmpeg:8.0-ubuntu
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "ffmpeg-8.0-libavcodec62";
  tag = "8.0-ubuntu";
  config.Labels = {
    "org.opencontainers.image.version" = "8.0-ubuntu";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/jrottenberg/ffmpeg:8.0-ubuntu directly.";
    "io.nix-containers.upstream-image" = "docker.io/jrottenberg/ffmpeg:8.0-ubuntu";
    "io.nix-containers.image.upstream" = "docker.io/jrottenberg/ffmpeg";
  };
}
