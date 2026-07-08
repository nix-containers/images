{ nix2container, lib, pkgs, ... }:

# cephcsi-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: quay.io/cephcsi/cephcsi:v3.17.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "cephcsi-fips";
  tag = "v3.17.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v3.17.0";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/cephcsi/cephcsi:v3.17.0 directly.";
    "io.nix-containers.upstream-image" = "quay.io/cephcsi/cephcsi:v3.17.0";
    "io.nix-containers.image.upstream" = "quay.io/cephcsi/cephcsi";
  };
}
