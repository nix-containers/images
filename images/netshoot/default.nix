{ nix2container, lib, pkgs, ... }:

# netshoot — UPSTREAM REFERENCE (not built/hosted). Use docker.io/nicolaka/netshoot:v0.16 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "netshoot";
  tag = "v0.16";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.16";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/nicolaka/netshoot:v0.16 directly.";
    "io.nix-containers.upstream-image" = "docker.io/nicolaka/netshoot:v0.16";
    "io.nix-containers.image.upstream" = "docker.io/nicolaka/netshoot";
  };
}
