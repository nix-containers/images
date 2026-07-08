{ nix2container, lib, pkgs, ... }:

# linkerd-web — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/linkerd/web:stable-2.11.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "linkerd-web";
  tag = "stable-2.11.1";
  config.Labels = {
    "org.opencontainers.image.version" = "stable-2.11.1";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/linkerd/web:stable-2.11.1 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/linkerd/web:stable-2.11.1";
    "io.nix-containers.image.upstream" = "ghcr.io/linkerd/web";
  };
}
