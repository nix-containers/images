{ nix2container, lib, pkgs, ... }:

# infinispan — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/infinispan/server:16.0.14
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "infinispan";
  tag = "16.0.14";
  config.Labels = {
    "org.opencontainers.image.version" = "16.0.14";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/infinispan/server:16.0.14 directly.";
    "io.nix-containers.upstream-image" = "docker.io/infinispan/server:16.0.14";
    "io.nix-containers.image.upstream" = "docker.io/infinispan/server";
  };
}
