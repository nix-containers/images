{ nix2container, lib, pkgs, ... }:

# apisix-ingress-controller — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/apache/apisix-ingress-controller:2.1.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "apisix-ingress-controller";
  tag = "2.1.0";
  config.Labels = {
    "org.opencontainers.image.version" = "2.1.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/apache/apisix-ingress-controller:2.1.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/apache/apisix-ingress-controller:2.1.0";
    "io.nix-containers.image.upstream" = "docker.io/apache/apisix-ingress-controller";
  };
}
