{ nix2container, lib, pkgs, ... }:

# geoip-api — UPSTREAM REFERENCE (not built/hosted). Use ghcr.io/observabilitystack/geoip-api:2023-11 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "geoip-api";
  tag = "2023-11";
  config.Labels = {
    "org.opencontainers.image.version" = "2023-11";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/observabilitystack/geoip-api:2023-11 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/observabilitystack/geoip-api:2023-11";
    "io.nix-containers.image.upstream" = "ghcr.io/observabilitystack/geoip-api";
  };
}
