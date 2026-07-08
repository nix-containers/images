{ nix2container, lib, pkgs, ... }:

# conda-init — UPSTREAM REFERENCE (not built/hosted). Use docker.io/continuumio/miniconda3:latest directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "conda-init";
  tag = "latest";
  config.Labels = {
    "org.opencontainers.image.version" = "latest";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/continuumio/miniconda3:latest directly.";
    "io.nix-containers.upstream-image" = "docker.io/continuumio/miniconda3:latest";
    "io.nix-containers.image.upstream" = "docker.io/continuumio/miniconda3";
  };
}
