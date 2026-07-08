{ nix2container, lib, pkgs, ... }:

# postgres-cloudnative-pg-fips — UPSTREAM REFERENCE (not built/hosted). Use ghcr.io/cloudnative-pg/postgresql:17.2 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "postgres-cloudnative-pg-fips";
  tag = "17.2";
  config.Labels = {
    "org.opencontainers.image.version" = "17.2";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/cloudnative-pg/postgresql:17.2 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/cloudnative-pg/postgresql:17.2";
    "io.nix-containers.image.upstream" = "ghcr.io/cloudnative-pg/postgresql";
  };
}
