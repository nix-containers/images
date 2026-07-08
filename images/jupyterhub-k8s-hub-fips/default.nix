{ nix2container, lib, pkgs, ... }:

# jupyterhub-k8s-hub-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/jupyterhub/k8s-hub:4.4.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "jupyterhub-k8s-hub-fips";
  tag = "4.4.0";
  config.Labels = {
    "org.opencontainers.image.version" = "4.4.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/jupyterhub/k8s-hub:4.4.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/jupyterhub/k8s-hub:4.4.0";
    "io.nix-containers.image.upstream" = "docker.io/jupyterhub/k8s-hub";
  };
}
