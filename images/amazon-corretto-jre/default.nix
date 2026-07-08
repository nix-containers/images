{ nix2container, lib, pkgs, ... }:

# amazon-corretto-jre — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/amazoncorretto:21
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "amazon-corretto-jre";
  tag = "21";
  config.Labels = {
    "org.opencontainers.image.version" = "21";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/amazoncorretto:21 directly.";
    "io.nix-containers.upstream-image" = "docker.io/amazoncorretto:21";
    "io.nix-containers.image.upstream" = "docker.io/amazoncorretto";
  };
}
