{ nix2container, lib, pkgs, ... }:

# jupyter-base-notebook — UPSTREAM REFERENCE (not built/hosted). Use quay.io/jupyter/base-notebook:notebook-7.6.0 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "jupyter-base-notebook";
  tag = "notebook-7.6.0";
  config.Labels = {
    "org.opencontainers.image.version" = "notebook-7.6.0";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/jupyter/base-notebook:notebook-7.6.0 directly.";
    "io.nix-containers.upstream-image" = "quay.io/jupyter/base-notebook:notebook-7.6.0";
    "io.nix-containers.image.upstream" = "quay.io/jupyter/base-notebook";
  };
}
