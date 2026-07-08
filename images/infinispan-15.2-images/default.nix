{ nix2container, lib, pkgs, ... }:

# infinispan-15.2-images — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/infinispan/server:15.2.6.Final
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "infinispan-15.2-images";
  tag = "15.2.6.Final";
  config.Labels = {
    "org.opencontainers.image.version" = "15.2.6.Final";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/infinispan/server:15.2.6.Final directly.";
    "io.nix-containers.upstream-image" = "docker.io/infinispan/server:15.2.6.Final";
    "io.nix-containers.image.upstream" = "docker.io/infinispan/server";
  };
}
