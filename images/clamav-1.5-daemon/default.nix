{ nix2container, lib, pkgs, ... }:

# clamav-1.5-daemon — UPSTREAM REFERENCE (not built/hosted). Use docker.io/clamav/clamav:1.5.3 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "clamav-1.5-daemon";
  tag = "1.5.3";
  config.Labels = {
    "org.opencontainers.image.version" = "1.5.3";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/clamav/clamav:1.5.3 directly.";
    "io.nix-containers.upstream-image" = "docker.io/clamav/clamav:1.5.3";
    "io.nix-containers.image.upstream" = "docker.io/clamav/clamav";
  };
}
