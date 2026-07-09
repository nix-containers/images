{ nix2container, lib, pkgs, ... }:

# ztunnel-fips — UPSTREAM REFERENCE (not built/hosted). Use docker.io/istio/ztunnel:1.30.2 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "ztunnel-fips";
  tag = "1.30.2";
  config.Labels = {
    "org.opencontainers.image.version" = "1.30.2";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/istio/ztunnel:1.30.2 directly.";
    "io.nix-containers.upstream-image" = "docker.io/istio/ztunnel:1.30.2";
    "io.nix-containers.image.upstream" = "docker.io/istio/ztunnel";
  };
}
