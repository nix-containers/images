{ nix2container, lib, pkgs, ... }:

# ingress-nginx-controller-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: registry.k8s.io/ingress-nginx/controller:v1.12.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "ingress-nginx-controller-fips";
  tag = "v1.12.1";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.12.1";
    "org.opencontainers.image.description" = "Upstream reference — pull registry.k8s.io/ingress-nginx/controller:v1.12.1 directly.";
    "io.nix-containers.upstream-image" = "registry.k8s.io/ingress-nginx/controller:v1.12.1";
    "io.nix-containers.image.upstream" = "registry.k8s.io/ingress-nginx/controller";
  };
}
