{ nix2container, lib, pkgs, ... }:

# victoriametrics-vminsert — UPSTREAM REFERENCE (not built/hosted). Use docker.io/victoriametrics/vminsert:v1.147.0-cluster directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "victoriametrics-vminsert";
  tag = "v1.147.0-cluster";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.147.0-cluster";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/victoriametrics/vminsert:v1.147.0-cluster directly.";
    "io.nix-containers.upstream-image" = "docker.io/victoriametrics/vminsert:v1.147.0-cluster";
    "io.nix-containers.image.upstream" = "docker.io/victoriametrics/vminsert";
  };
}
