{ nix2container, lib, pkgs, ... }:

# spicedb-operator-fips — UPSTREAM REFERENCE (not built/hosted). Use ghcr.io/authzed/spicedb-operator:v1.20.0 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "spicedb-operator-fips";
  tag = "v1.20.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.20.0";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/authzed/spicedb-operator:v1.20.0 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/authzed/spicedb-operator:v1.20.0";
    "io.nix-containers.image.upstream" = "ghcr.io/authzed/spicedb-operator";
  };
}
