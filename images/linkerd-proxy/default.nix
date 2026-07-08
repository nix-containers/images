{ nix2container, lib, pkgs, ... }:

# linkerd-proxy — UPSTREAM REFERENCE (not built/hosted). Use cr.l5d.io/linkerd/proxy:stable-2.11.1 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "linkerd-proxy";
  tag = "stable-2.11.1";
  config.Labels = {
    "org.opencontainers.image.version" = "stable-2.11.1";
    "org.opencontainers.image.description" = "Upstream reference — pull cr.l5d.io/linkerd/proxy:stable-2.11.1 directly.";
    "io.nix-containers.upstream-image" = "cr.l5d.io/linkerd/proxy:stable-2.11.1";
    "io.nix-containers.image.upstream" = "cr.l5d.io/linkerd/proxy";
  };
}
