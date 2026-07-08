{ nix2container, lib, pkgs, ... }:

# python-3.10-base — UPSTREAM REFERENCE (not built/hosted). Use docker.io/library/python:3.10 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "python-3.10-base";
  tag = "3.10";
  config.Labels = {
    "org.opencontainers.image.version" = "3.10";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/library/python:3.10 directly.";
    "io.nix-containers.upstream-image" = "docker.io/library/python:3.10";
    "io.nix-containers.image.upstream" = "docker.io/library/python";
  };
}
