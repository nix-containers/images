{ nix2container, lib, pkgs, ... }:

# grafana-operator-fips — UPSTREAM REFERENCE (not built/hosted). Use ghcr.io/grafana/grafana-operator:v5.13.0 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "grafana-operator-fips";
  tag = "v5.13.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v5.13.0";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/grafana/grafana-operator:v5.13.0 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/grafana/grafana-operator:v5.13.0";
    "io.nix-containers.image.upstream" = "ghcr.io/grafana/grafana-operator";
  };
}
