{ nix2container, lib, pkgs, ... }:

# python-3.14-base — UPSTREAM REFERENCE (not built/hosted). Use docker.io/library/python:3.14 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "python-3.14-base";
  tag = "3.14";
  config.Labels = {
    "org.opencontainers.image.version" = "3.14";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/library/python:3.14 directly.";
    "io.nix-containers.upstream-image" = "docker.io/library/python:3.14";
    "io.nix-containers.image.upstream" = "docker.io/library/python";
  };
}
