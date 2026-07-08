{ nix2container, lib, pkgs, ... }:

# minio-object-browser-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: quay.io/minio/console:v0.30.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "minio-object-browser-fips";
  tag = "v0.30.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.30.0";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/minio/console:v0.30.0 directly.";
    "io.nix-containers.upstream-image" = "quay.io/minio/console:v0.30.0";
    "io.nix-containers.image.upstream" = "quay.io/minio/console";
  };
}
