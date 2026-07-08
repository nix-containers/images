{ nix2container, lib, pkgs, ... }:

# linkerd-proxy-init — UPSTREAM REFERENCE (not built/hosted). Use cr.l5d.io/linkerd/proxy-init:v2.4.9 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "linkerd-proxy-init";
  tag = "v2.4.9";
  config.Labels = {
    "org.opencontainers.image.version" = "v2.4.9";
    "org.opencontainers.image.description" = "Upstream reference — pull cr.l5d.io/linkerd/proxy-init:v2.4.9 directly.";
    "io.nix-containers.upstream-image" = "cr.l5d.io/linkerd/proxy-init:v2.4.9";
    "io.nix-containers.image.upstream" = "cr.l5d.io/linkerd/proxy-init";
  };
}
