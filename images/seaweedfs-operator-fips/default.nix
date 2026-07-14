{ nix2container, lib, pkgs, ... }:

# seaweedfs-operator-fips — UPSTREAM REFERENCE (not built/hosted). Use ghcr.io/seaweedfs/seaweedfs-operator:1.0.31 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "seaweedfs-operator-fips";
  tag = "1.0.32";
  config.Labels = {
    "org.opencontainers.image.version" = "1.0.32";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/seaweedfs/seaweedfs-operator:1.0.31 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/seaweedfs/seaweedfs-operator:1.0.31";
    "io.nix-containers.image.upstream" = "ghcr.io/seaweedfs/seaweedfs-operator";
  };
}
