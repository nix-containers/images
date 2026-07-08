{ nix2container, lib, pkgs, ... }:

# clamav-1.5-freshclam — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/clamav/clamav:1.5.3
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "clamav-1.5-freshclam";
  tag = "1.5.3";
  config.Labels = {
    "org.opencontainers.image.version" = "1.5.3";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/clamav/clamav:1.5.3 directly.";
    "io.nix-containers.upstream-image" = "docker.io/clamav/clamav:1.5.3";
    "io.nix-containers.image.upstream" = "docker.io/clamav/clamav";
  };
}
