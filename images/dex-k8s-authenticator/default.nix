{ nix2container, lib, pkgs, ... }:

# dex-k8s-authenticator — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/mintel/dex-k8s-authenticator:1.4.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "dex-k8s-authenticator";
  tag = "1.4.0";
  config.Labels = {
    "org.opencontainers.image.version" = "1.4.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/mintel/dex-k8s-authenticator:1.4.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/mintel/dex-k8s-authenticator:1.4.0";
    "io.nix-containers.image.upstream" = "docker.io/mintel/dex-k8s-authenticator";
  };
}
