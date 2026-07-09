{ nix2container, lib, pkgs, ... }:

# openjdk-bcfips-policy-140-3-j21 — UPSTREAM REFERENCE (not built/hosted). Use docker.io/eclipse-temurin:21 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "openjdk-bcfips-policy-140-3-j21";
  tag = "21";
  config.Labels = {
    "org.opencontainers.image.version" = "21";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/eclipse-temurin:21 directly.";
    "io.nix-containers.upstream-image" = "docker.io/eclipse-temurin:21";
    "io.nix-containers.image.upstream" = "docker.io/eclipse-temurin";
  };
}
