{ nix2container, lib, pkgs, ... }:

# ffmpeg-cuda-7.1-nozeromq — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/jrottenberg/ffmpeg:8.0-nvidia
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "ffmpeg-cuda-7.1-nozeromq";
  tag = "8.0-nvidia";
  config.Labels = {
    "org.opencontainers.image.version" = "8.0-nvidia";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/jrottenberg/ffmpeg:8.0-nvidia directly.";
    "io.nix-containers.upstream-image" = "docker.io/jrottenberg/ffmpeg:8.0-nvidia";
    "io.nix-containers.image.upstream" = "docker.io/jrottenberg/ffmpeg";
  };
}
