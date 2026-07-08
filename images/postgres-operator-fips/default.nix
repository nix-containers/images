{ nix2container, lib, pkgs, ... }:

# postgres-operator-fips — UPSTREAM REFERENCE (not built/hosted). Use ghcr.io/zalando/postgres-operator:v1.15.1 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "postgres-operator-fips";
  tag = "v1.15.1";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.15.1";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/zalando/postgres-operator:v1.15.1 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/zalando/postgres-operator:v1.15.1";
    "io.nix-containers.image.upstream" = "ghcr.io/zalando/postgres-operator";
  };
}
