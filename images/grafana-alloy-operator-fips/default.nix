{ nix2container, lib, pkgs, ... }:

# grafana-alloy-operator-fips — UPSTREAM REFERENCE (not built/hosted). Use ghcr.io/grafana/alloy-operator:1.10.0 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "grafana-alloy-operator-fips";
  tag = "1.10.1";
  config.Labels = {
    "org.opencontainers.image.version" = "1.10.1";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/grafana/alloy-operator:1.10.0 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/grafana/alloy-operator:1.10.0";
    "io.nix-containers.image.upstream" = "ghcr.io/grafana/alloy-operator";
  };
}
