{ nix2container, lib, pkgs, ... }:

# electric — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/electricsql/electric:1.7.7
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "electric";
  tag = "1.7.7";
  config.Labels = {
    "org.opencontainers.image.version" = "1.7.7";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/electricsql/electric:1.7.7 directly.";
    "io.nix-containers.upstream-image" = "docker.io/electricsql/electric:1.7.7";
    "io.nix-containers.image.upstream" = "docker.io/electricsql/electric";
  };
}
