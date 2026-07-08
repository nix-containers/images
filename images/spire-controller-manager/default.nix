{ nix2container, lib, pkgs, ... }:

# spire-controller-manager — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/spiffe/spire-controller-manager:0.6.6
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "spire-controller-manager";
  tag = "0.6.6";
  config.Labels = {
    "org.opencontainers.image.version" = "0.6.6";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/spiffe/spire-controller-manager:0.6.6 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/spiffe/spire-controller-manager:0.6.6";
    "io.nix-containers.image.upstream" = "ghcr.io/spiffe/spire-controller-manager";
  };
}
