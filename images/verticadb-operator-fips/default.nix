{ nix2container, lib, pkgs, ... }:

# verticadb-operator-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/opentext/verticadb-operator:2.2.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "verticadb-operator-fips";
  tag = "2.2.0";
  config.Labels = {
    "org.opencontainers.image.version" = "2.2.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/opentext/verticadb-operator:2.2.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/opentext/verticadb-operator:2.2.0";
    "io.nix-containers.image.upstream" = "docker.io/opentext/verticadb-operator";
  };
}
