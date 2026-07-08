{ nix2container, lib, pkgs, ... }:

# pgvector — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/pgvector/pgvector:0.8.4-pg17-trixie
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "pgvector";
  tag = "0.8.4-pg17-trixie";
  config.Labels = {
    "org.opencontainers.image.version" = "0.8.4-pg17-trixie";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/pgvector/pgvector:0.8.4-pg17-trixie directly.";
    "io.nix-containers.upstream-image" = "docker.io/pgvector/pgvector:0.8.4-pg17-trixie";
    "io.nix-containers.image.upstream" = "docker.io/pgvector/pgvector";
  };
}
