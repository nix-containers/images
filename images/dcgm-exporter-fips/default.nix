{ nix2container, lib, pkgs, ... }:

# dcgm-exporter-fips — UPSTREAM REFERENCE (not built/hosted). Use docker.io/nvidia/dcgm-exporter:4.5.2-4.8.1-ubuntu22.04 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "dcgm-exporter-fips";
  tag = "4.6.0";
  config.Labels = {
    "org.opencontainers.image.version" = "4.6.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/nvidia/dcgm-exporter:4.5.2-4.8.1-ubuntu22.04 directly.";
    "io.nix-containers.upstream-image" = "docker.io/nvidia/dcgm-exporter:4.5.2-4.8.1-ubuntu22.04";
    "io.nix-containers.image.upstream" = "docker.io/nvidia/dcgm-exporter";
  };
}
