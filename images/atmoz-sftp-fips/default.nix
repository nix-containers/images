{ nix2container, lib, pkgs, ... }:

# atmoz-sftp-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/atmoz/sftp:alpine
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "atmoz-sftp-fips";
  tag = "alpine";
  config.Labels = {
    "org.opencontainers.image.version" = "alpine";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/atmoz/sftp:alpine directly.";
    "io.nix-containers.upstream-image" = "docker.io/atmoz/sftp:alpine";
    "io.nix-containers.image.upstream" = "docker.io/atmoz/sftp";
  };
}
