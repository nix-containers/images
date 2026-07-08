{ nix2container, lib, pkgs, ... }:

# linkerd-tap — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/linkerd/tap:stable-2.12.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "linkerd-tap";
  tag = "stable-2.12.0";
  config.Labels = {
    "org.opencontainers.image.version" = "stable-2.12.0";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/linkerd/tap:stable-2.12.0 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/linkerd/tap:stable-2.12.0";
    "io.nix-containers.image.upstream" = "ghcr.io/linkerd/tap";
  };
}
