{ nix2container, lib, pkgs, ... }:

# gha-runner-scale-set-controller — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/actions/gha-runner-scale-set-controller:0.5.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "gha-runner-scale-set-controller";
  tag = "0.5.0";
  config.Labels = {
    "org.opencontainers.image.version" = "0.5.0";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/actions/gha-runner-scale-set-controller:0.5.0 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/actions/gha-runner-scale-set-controller:0.5.0";
    "io.nix-containers.image.upstream" = "ghcr.io/actions/gha-runner-scale-set-controller";
  };
}
