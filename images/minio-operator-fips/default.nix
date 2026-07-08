{ nix2container, lib, pkgs, ... }:

# minio-operator-fips — UPSTREAM REFERENCE (not built/hosted). Use quay.io/minio/operator:v7.1.1 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "minio-operator-fips";
  tag = "v7.1.1";
  config.Labels = {
    "org.opencontainers.image.version" = "v7.1.1";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/minio/operator:v7.1.1 directly.";
    "io.nix-containers.upstream-image" = "quay.io/minio/operator:v7.1.1";
    "io.nix-containers.image.upstream" = "quay.io/minio/operator";
  };
}
