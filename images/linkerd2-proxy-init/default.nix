{ nix2container, lib, pkgs, ... }:

# linkerd2-proxy-init — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/linkerd/proxy-init:v1.4.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "linkerd2-proxy-init";
  tag = "v1.4.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.4.0";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/linkerd/proxy-init:v1.4.0 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/linkerd/proxy-init:v1.4.0";
    "io.nix-containers.image.upstream" = "ghcr.io/linkerd/proxy-init";
  };
}
