{ nix2container, lib, pkgs, ... }:

# linkerd-extension-init — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/linkerd/extension-init:v0.1.11
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "linkerd-extension-init";
  tag = "v0.1.11";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.1.11";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/linkerd/extension-init:v0.1.11 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/linkerd/extension-init:v0.1.11";
    "io.nix-containers.image.upstream" = "ghcr.io/linkerd/extension-init";
  };
}
