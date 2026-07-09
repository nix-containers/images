{ nix2container, lib, pkgs, ... }:

# openjdk-bcfips-policy-140-3-j11 — UPSTREAM REFERENCE (not built/hosted). Use docker.io/eclipse-temurin:11 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "openjdk-bcfips-policy-140-3-j11";
  tag = "11";
  config.Labels = {
    "org.opencontainers.image.version" = "11";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/eclipse-temurin:11 directly.";
    "io.nix-containers.upstream-image" = "docker.io/eclipse-temurin:11";
    "io.nix-containers.image.upstream" = "docker.io/eclipse-temurin";
  };
}
