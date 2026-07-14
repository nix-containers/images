{ nix2container, lib, pkgs, ... }:

# pvc-autoresizer — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/topolvm/pvc-autoresizer:0.21.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "pvc-autoresizer";
  tag = "0.21";
  config.Labels = {
    "org.opencontainers.image.version" = "0.21";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/topolvm/pvc-autoresizer:0.21.0 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/topolvm/pvc-autoresizer:0.21.0";
    "io.nix-containers.image.upstream" = "ghcr.io/topolvm/pvc-autoresizer";
  };
}
