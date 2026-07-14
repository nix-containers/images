{ nix2container, lib, pkgs, ... }:

# infinispan-operator — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/infinispan/operator:2.1.3.Final
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "infinispan-operator";
  tag = "2.0.6";
  config.Labels = {
    "org.opencontainers.image.version" = "2.0.6";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/infinispan/operator:2.1.3.Final directly.";
    "io.nix-containers.upstream-image" = "docker.io/infinispan/operator:2.1.3.Final";
    "io.nix-containers.image.upstream" = "docker.io/infinispan/operator";
  };
}
