{ nix2container, lib, pkgs, ... }:

# rekor-fips-backfill-index — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: gcr.io/projectsigstore/rekor-server:v1.5.3
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "rekor-fips-backfill-index";
  tag = "v1.5.3";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.5.3";
    "org.opencontainers.image.description" = "Upstream reference — pull gcr.io/projectsigstore/rekor-server:v1.5.3 directly.";
    "io.nix-containers.upstream-image" = "gcr.io/projectsigstore/rekor-server:v1.5.3";
    "io.nix-containers.image.upstream" = "gcr.io/projectsigstore/rekor-server";
  };
}
