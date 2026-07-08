{ nix2container, lib, pkgs, ... }:

# db-operator — UPSTREAM REFERENCE (not built/hosted). Use ghcr.io/db-operator/db-operator:v2.7.0 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "db-operator";
  tag = "v2.7.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v2.7.0";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/db-operator/db-operator:v2.7.0 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/db-operator/db-operator:v2.7.0";
    "io.nix-containers.image.upstream" = "ghcr.io/db-operator/db-operator";
  };
}
