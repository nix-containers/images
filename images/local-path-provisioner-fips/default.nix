{ nix2container, lib, pkgs, ... }:

# local-path-provisioner-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/rancher/local-path-provisioner:v0.0.36
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "local-path-provisioner-fips";
  tag = "v0.0.36";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.0.36";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/rancher/local-path-provisioner:v0.0.36 directly.";
    "io.nix-containers.upstream-image" = "docker.io/rancher/local-path-provisioner:v0.0.36";
    "io.nix-containers.image.upstream" = "docker.io/rancher/local-path-provisioner";
  };
}
