{ nix2container, lib, pkgs, ... }:

# bitnami-shell — UPSTREAM REFERENCE (not built/hosted). Use docker.io/bitnami/minideb:bookworm directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "bitnami-shell";
  tag = "bookworm";
  config.Labels = {
    "org.opencontainers.image.version" = "bookworm";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/bitnami/minideb:bookworm directly.";
    "io.nix-containers.upstream-image" = "docker.io/bitnami/minideb:bookworm";
    "io.nix-containers.image.upstream" = "docker.io/bitnami/minideb";
  };
}
