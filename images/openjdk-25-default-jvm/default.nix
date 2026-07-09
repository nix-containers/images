{ nix2container, lib, pkgs, ... }:

# openjdk-25-default-jvm — UPSTREAM REFERENCE (not built/hosted). Use docker.io/eclipse-temurin:25-jdk directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "openjdk-25-default-jvm";
  tag = "25-jdk";
  config.Labels = {
    "org.opencontainers.image.version" = "25-jdk";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/eclipse-temurin:25-jdk directly.";
    "io.nix-containers.upstream-image" = "docker.io/eclipse-temurin:25-jdk";
    "io.nix-containers.image.upstream" = "docker.io/eclipse-temurin";
  };
}
