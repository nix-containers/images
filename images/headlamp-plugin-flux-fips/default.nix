{ nix2container, lib, pkgs, ... }:

# headlamp-plugin-flux-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/headlamp-k8s/headlamp:v0.22.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "headlamp-plugin-flux-fips";
  tag = "v0.22.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.22.0";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/headlamp-k8s/headlamp:v0.22.0 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/headlamp-k8s/headlamp:v0.22.0";
    "io.nix-containers.image.upstream" = "ghcr.io/headlamp-k8s/headlamp";
  };
}
