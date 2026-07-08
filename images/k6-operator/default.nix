{ nix2container, lib, pkgs, ... }:

# k6-operator — UPSTREAM REFERENCE (not built/hosted). Use ghcr.io/grafana/k6-operator:controller-v0.0.14 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "k6-operator";
  tag = "controller-v0.0.14";
  config.Labels = {
    "org.opencontainers.image.version" = "controller-v0.0.14";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/grafana/k6-operator:controller-v0.0.14 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/grafana/k6-operator:controller-v0.0.14";
    "io.nix-containers.image.upstream" = "ghcr.io/grafana/k6-operator";
  };
}
