{ nix2container, lib, pkgs, ... }:

# openjdk-crac-25-jre-base — UPSTREAM REFERENCE (not built/hosted). Use docker.io/eclipse-temurin:25-jre directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "openjdk-crac-25-jre-base";
  tag = "25-jre";
  config.Labels = {
    "org.opencontainers.image.version" = "25-jre";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/eclipse-temurin:25-jre directly.";
    "io.nix-containers.upstream-image" = "docker.io/eclipse-temurin:25-jre";
    "io.nix-containers.image.upstream" = "docker.io/eclipse-temurin";
  };
}
