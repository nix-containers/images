{ nix2container, lib, pkgs, ... }:

# linkerd2-metrics-api — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/linkerd/metrics-api:stable-2.14.10
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "linkerd2-metrics-api";
  tag = "stable-2.14.10";
  config.Labels = {
    "org.opencontainers.image.version" = "stable-2.14.10";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/linkerd/metrics-api:stable-2.14.10 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/linkerd/metrics-api:stable-2.14.10";
    "io.nix-containers.image.upstream" = "ghcr.io/linkerd/metrics-api";
  };
}
