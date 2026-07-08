{ nix2container, lib, pkgs, ... }:

# vc-scheduler — UPSTREAM REFERENCE (not built/hosted). Use docker.io/volcanosh/vc-scheduler:v1.15.0 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "vc-scheduler";
  tag = "v1.15.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.15.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/volcanosh/vc-scheduler:v1.15.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/volcanosh/vc-scheduler:v1.15.0";
    "io.nix-containers.image.upstream" = "docker.io/volcanosh/vc-scheduler";
  };
}
