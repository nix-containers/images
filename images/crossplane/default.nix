{ nix2container, lib, pkgs, ... }:

# crossplane — UPSTREAM REFERENCE (not built/hosted). Use docker.io/crossplane/crossplane:v2.3.3 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "crossplane";
  tag = "v2.3.3";
  config.Labels = {
    "org.opencontainers.image.version" = "v2.3.3";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/crossplane/crossplane:v2.3.3 directly.";
    "io.nix-containers.upstream-image" = "docker.io/crossplane/crossplane:v2.3.3";
    "io.nix-containers.image.upstream" = "docker.io/crossplane/crossplane";
  };
}
