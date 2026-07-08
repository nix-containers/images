{ nix2container, lib, pkgs, ... }:

# temporal-admin-tools-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/temporalio/admin-tools:1.31.2
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "temporal-admin-tools-fips";
  tag = "1.31.2";
  config.Labels = {
    "org.opencontainers.image.version" = "1.31.2";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/temporalio/admin-tools:1.31.2 directly.";
    "io.nix-containers.upstream-image" = "docker.io/temporalio/admin-tools:1.31.2";
    "io.nix-containers.image.upstream" = "docker.io/temporalio/admin-tools";
  };
}
