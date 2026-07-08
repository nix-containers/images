{ nix2container, lib, pkgs, ... }:

# clickhouse-operator-fips — UPSTREAM REFERENCE (not built/hosted). Use docker.io/altinity/clickhouse-operator:0.27.2 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "clickhouse-operator-fips";
  tag = "0.27.2";
  config.Labels = {
    "org.opencontainers.image.version" = "0.27.2";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/altinity/clickhouse-operator:0.27.2 directly.";
    "io.nix-containers.upstream-image" = "docker.io/altinity/clickhouse-operator:0.27.2";
    "io.nix-containers.image.upstream" = "docker.io/altinity/clickhouse-operator";
  };
}
