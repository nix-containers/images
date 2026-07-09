{ nix2container, lib, pkgs, ... }:

# cert-manager-acmesolver — UPSTREAM REFERENCE (not built/hosted). Use quay.io/jetstack/cert-manager-acmesolver:v1.9.2 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "cert-manager-acmesolver";
  tag = "v1.9.2";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.9.2";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/jetstack/cert-manager-acmesolver:v1.9.2 directly.";
    "io.nix-containers.upstream-image" = "quay.io/jetstack/cert-manager-acmesolver:v1.9.2";
    "io.nix-containers.image.upstream" = "quay.io/jetstack/cert-manager-acmesolver";
  };
}
