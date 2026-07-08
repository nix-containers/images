{ nix2container, lib, pkgs, ... }:

# neuvector-prometheus-exporter-fips — UPSTREAM REFERENCE (not built/hosted). Use docker.io/neuvector/prometheus-exporter:1.0.14 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "neuvector-prometheus-exporter-fips";
  tag = "1.0.14";
  config.Labels = {
    "org.opencontainers.image.version" = "1.0.14";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/neuvector/prometheus-exporter:1.0.14 directly.";
    "io.nix-containers.upstream-image" = "docker.io/neuvector/prometheus-exporter:1.0.14";
    "io.nix-containers.image.upstream" = "docker.io/neuvector/prometheus-exporter";
  };
}
