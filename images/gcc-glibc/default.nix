{ nix2container, lib, pkgs, ... }:

# gcc-glibc — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/library/gcc:14.4.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "gcc-glibc";
  tag = "16.1.0";
  config.Labels = {
    "org.opencontainers.image.version" = "16.1.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/library/gcc:14.4.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/library/gcc:14.4.0";
    "io.nix-containers.image.upstream" = "docker.io/library/gcc";
  };
}
