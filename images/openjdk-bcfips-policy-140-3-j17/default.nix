{ nix2container, lib, pkgs, ... }:

# openjdk-bcfips-policy-140-3-j17 — UPSTREAM REFERENCE (not built/hosted). Use docker.io/eclipse-temurin:17 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "openjdk-bcfips-policy-140-3-j17";
  tag = "17";
  config.Labels = {
    "org.opencontainers.image.version" = "17";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/eclipse-temurin:17 directly.";
    "io.nix-containers.upstream-image" = "docker.io/eclipse-temurin:17";
    "io.nix-containers.image.upstream" = "docker.io/eclipse-temurin";
  };
}
