{ nix2container, lib, pkgs, ... }:

# clickhouse-operator-fips-metrics-exporter — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/altinity/metrics-exporter:0.27.2
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "clickhouse-operator-fips-metrics-exporter";
  tag = "0.27.2";
  config.Labels = {
    "org.opencontainers.image.version" = "0.27.2";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/altinity/metrics-exporter:0.27.2 directly.";
    "io.nix-containers.upstream-image" = "docker.io/altinity/metrics-exporter:0.27.2";
    "io.nix-containers.image.upstream" = "docker.io/altinity/metrics-exporter";
  };
}
