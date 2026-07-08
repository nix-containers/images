{ nix2container, lib, pkgs, ... }:

# flannel-cni-plugin-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/flannel/flannel-cni-plugin:v1.5.1-flannel1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "flannel-cni-plugin-fips";
  tag = "v1.5.1-flannel1";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.5.1-flannel1";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/flannel/flannel-cni-plugin:v1.5.1-flannel1 directly.";
    "io.nix-containers.upstream-image" = "docker.io/flannel/flannel-cni-plugin:v1.5.1-flannel1";
    "io.nix-containers.image.upstream" = "docker.io/flannel/flannel-cni-plugin";
  };
}
