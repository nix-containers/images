{ nix2container, lib, pkgs, ... }:

# linkerd-metrics-api — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/linkerd/metrics-api:stable-2.11.4
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "linkerd-metrics-api";
  tag = "stable-2.11.4";
  config.Labels = {
    "org.opencontainers.image.version" = "stable-2.11.4";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/linkerd/metrics-api:stable-2.11.4 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/linkerd/metrics-api:stable-2.11.4";
    "io.nix-containers.image.upstream" = "ghcr.io/linkerd/metrics-api";
  };
}
