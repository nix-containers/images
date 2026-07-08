{ nix2container, lib, pkgs, ... }:

# neo4j-2025.10-browser — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/library/neo4j:2025.10.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "neo4j-2025.10-browser";
  tag = "2025.10.1";
  config.Labels = {
    "org.opencontainers.image.version" = "2025.10.1";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/library/neo4j:2025.10.1 directly.";
    "io.nix-containers.upstream-image" = "docker.io/library/neo4j:2025.10.1";
    "io.nix-containers.image.upstream" = "docker.io/library/neo4j";
  };
}
