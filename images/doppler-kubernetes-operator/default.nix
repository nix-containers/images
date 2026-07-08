{ nix2container, lib, pkgs, ... }:

# doppler-kubernetes-operator — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/dopplerhq/kubernetes-operator:1.7.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "doppler-kubernetes-operator";
  tag = "1.7.1";
  config.Labels = {
    "org.opencontainers.image.version" = "1.7.1";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/dopplerhq/kubernetes-operator:1.7.1 directly.";
    "io.nix-containers.upstream-image" = "docker.io/dopplerhq/kubernetes-operator:1.7.1";
    "io.nix-containers.image.upstream" = "docker.io/dopplerhq/kubernetes-operator";
  };
}
