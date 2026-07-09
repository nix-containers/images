{ nix2container, lib, pkgs, ... }:

# victoriametrics-vmselect-fips — UPSTREAM REFERENCE (not built/hosted). Use docker.io/victoriametrics/vmselect:v1.147.0-enterprise-cluster-fips directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "victoriametrics-vmselect-fips";
  tag = "v1.147.0-enterprise-cluster-fips";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.147.0-enterprise-cluster-fips";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/victoriametrics/vmselect:v1.147.0-enterprise-cluster-fips directly.";
    "io.nix-containers.upstream-image" = "docker.io/victoriametrics/vmselect:v1.147.0-enterprise-cluster-fips";
    "io.nix-containers.image.upstream" = "docker.io/victoriametrics/vmselect";
  };
}
