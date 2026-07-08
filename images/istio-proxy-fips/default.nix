{ nix2container, lib, pkgs, ... }:

# istio-proxy-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/istio/proxyv2:1.28.10
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "istio-proxy-fips";
  tag = "1.28.10";
  config.Labels = {
    "org.opencontainers.image.version" = "1.28.10";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/istio/proxyv2:1.28.10 directly.";
    "io.nix-containers.upstream-image" = "docker.io/istio/proxyv2:1.28.10";
    "io.nix-containers.image.upstream" = "docker.io/istio/proxyv2";
  };
}
