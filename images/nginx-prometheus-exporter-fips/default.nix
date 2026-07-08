{ nix2container, lib, pkgs, ... }:

# nginx-prometheus-exporter-fips — UPSTREAM REFERENCE (not built/hosted). Use docker.io/nginx/nginx-prometheus-exporter:1.5.1 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "nginx-prometheus-exporter-fips";
  tag = "1.5.1";
  config.Labels = {
    "org.opencontainers.image.version" = "1.5.1";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/nginx/nginx-prometheus-exporter:1.5.1 directly.";
    "io.nix-containers.upstream-image" = "docker.io/nginx/nginx-prometheus-exporter:1.5.1";
    "io.nix-containers.image.upstream" = "docker.io/nginx/nginx-prometheus-exporter";
  };
}
