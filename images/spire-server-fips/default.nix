{ nix2container, lib, pkgs, ... }:

# spire-server-fips — UPSTREAM REFERENCE (not built/hosted). Use ghcr.io/spiffe/spire-server:1.15.1 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "spire-server-fips";
  tag = "1.15.1";
  config.Labels = {
    "org.opencontainers.image.version" = "1.15.1";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/spiffe/spire-server:1.15.1 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/spiffe/spire-server:1.15.1";
    "io.nix-containers.image.upstream" = "ghcr.io/spiffe/spire-server";
  };
}
