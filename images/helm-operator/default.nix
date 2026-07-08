{ nix2container, lib, pkgs, ... }:

# helm-operator — UPSTREAM REFERENCE (not built/hosted). Use docker.io/fluxcd/helm-operator:1.4.4 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "helm-operator";
  tag = "1.4.4";
  config.Labels = {
    "org.opencontainers.image.version" = "1.4.4";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/fluxcd/helm-operator:1.4.4 directly.";
    "io.nix-containers.upstream-image" = "docker.io/fluxcd/helm-operator:1.4.4";
    "io.nix-containers.image.upstream" = "docker.io/fluxcd/helm-operator";
  };
}
