{ nix2container, lib, pkgs, ... }:

# mariadb-operator — UPSTREAM REFERENCE (not built/hosted). Use ghcr.io/mariadb-operator/mariadb-operator:26.6.0 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "mariadb-operator";
  tag = "26.6.0";
  config.Labels = {
    "org.opencontainers.image.version" = "26.6.0";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/mariadb-operator/mariadb-operator:26.6.0 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/mariadb-operator/mariadb-operator:26.6.0";
    "io.nix-containers.image.upstream" = "ghcr.io/mariadb-operator/mariadb-operator";
  };
}
