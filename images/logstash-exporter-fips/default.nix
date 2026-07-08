{ nix2container, lib, pkgs, ... }:

# logstash-exporter-fips — UPSTREAM REFERENCE (not built/hosted). Use ghcr.io/kuskoman/logstash-exporter:v1.9.1 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "logstash-exporter-fips";
  tag = "v1.9.1";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.9.1";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/kuskoman/logstash-exporter:v1.9.1 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/kuskoman/logstash-exporter:v1.9.1";
    "io.nix-containers.image.upstream" = "ghcr.io/kuskoman/logstash-exporter";
  };
}
