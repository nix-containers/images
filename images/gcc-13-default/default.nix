{ nix2container, lib, pkgs, ... }:

# gcc-13-default — UPSTREAM REFERENCE (not built/hosted). Use docker.io/library/gcc:13.4.0 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "gcc-13-default";
  tag = "13.4.0";
  config.Labels = {
    "org.opencontainers.image.version" = "13.4.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/library/gcc:13.4.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/library/gcc:13.4.0";
    "io.nix-containers.image.upstream" = "docker.io/library/gcc";
  };
}
