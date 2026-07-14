{ nix2container, lib, pkgs, ... }:

# timescaledb-oci-entrypoint-pg17 — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/timescale/timescaledb:2.28.2-pg17
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "timescaledb-oci-entrypoint-pg17";
  tag = "0.6.1";
  config.Labels = {
    "org.opencontainers.image.version" = "0.6.1";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/timescale/timescaledb:2.28.2-pg17 directly.";
    "io.nix-containers.upstream-image" = "docker.io/timescale/timescaledb:2.28.2-pg17";
    "io.nix-containers.image.upstream" = "docker.io/timescale/timescaledb";
  };
}
