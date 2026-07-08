{ nix2container, lib, pkgs, ... }:

# minio-operator-sidecar-fips — UPSTREAM REFERENCE (not built/hosted). Use quay.io/minio/operator-sidecar:v7.1.0 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "minio-operator-sidecar-fips";
  tag = "v7.1.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v7.1.0";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/minio/operator-sidecar:v7.1.0 directly.";
    "io.nix-containers.upstream-image" = "quay.io/minio/operator-sidecar:v7.1.0";
    "io.nix-containers.image.upstream" = "quay.io/minio/operator-sidecar";
  };
}
