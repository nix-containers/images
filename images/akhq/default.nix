{ nix2container, lib, pkgs, ... }:

# akhq — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/tchiotludo/akhq:0.27.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "akhq";
  tag = "0.27.1";
  config.Labels = {
    "org.opencontainers.image.version" = "0.27.1";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/tchiotludo/akhq:0.27.1 directly.";
    "io.nix-containers.upstream-image" = "docker.io/tchiotludo/akhq:0.27.1";
    "io.nix-containers.image.upstream" = "docker.io/tchiotludo/akhq";
  };
}
