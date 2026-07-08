{ nix2container, lib, pkgs, ... }:

# kapp-controller-fips — UPSTREAM REFERENCE (not built/hosted). Use ghcr.io/carvel-dev/kapp-controller:latest directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "kapp-controller-fips";
  tag = "latest";
  config.Labels = {
    "org.opencontainers.image.version" = "latest";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/carvel-dev/kapp-controller:latest directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/carvel-dev/kapp-controller:latest";
    "io.nix-containers.image.upstream" = "ghcr.io/carvel-dev/kapp-controller";
  };
}
