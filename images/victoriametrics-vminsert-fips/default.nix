{ nix2container, lib, pkgs, ... }:

# victoriametrics-vminsert-fips — UPSTREAM REFERENCE (not built/hosted). Use docker.io/victoriametrics/vminsert:v1.147.0-enterprise-cluster-fips directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "victoriametrics-vminsert-fips";
  tag = "v1.147.0-enterprise-cluster-fips";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.147.0-enterprise-cluster-fips";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/victoriametrics/vminsert:v1.147.0-enterprise-cluster-fips directly.";
    "io.nix-containers.upstream-image" = "docker.io/victoriametrics/vminsert:v1.147.0-enterprise-cluster-fips";
    "io.nix-containers.image.upstream" = "docker.io/victoriametrics/vminsert";
  };
}
