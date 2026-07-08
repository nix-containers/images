{ nix2container, lib, pkgs, ... }:

# k8sgpt-operator — UPSTREAM REFERENCE (not built/hosted). Use ghcr.io/k8sgpt-ai/k8sgpt-operator:v0.0.15 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "k8sgpt-operator";
  tag = "v0.0.15";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.0.15";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/k8sgpt-ai/k8sgpt-operator:v0.0.15 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/k8sgpt-ai/k8sgpt-operator:v0.0.15";
    "io.nix-containers.image.upstream" = "ghcr.io/k8sgpt-ai/k8sgpt-operator";
  };
}
