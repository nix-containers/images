{ nix2container, lib, pkgs, ... }:

# ingress-nginx-opentelemetry-plugin — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: registry.k8s.io/ingress-nginx/opentelemetry:v20230721-3e2062ee5
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "ingress-nginx-opentelemetry-plugin";
  tag = "v20230721-3e2062ee5";
  config.Labels = {
    "org.opencontainers.image.version" = "v20230721-3e2062ee5";
    "org.opencontainers.image.description" = "Upstream reference — pull registry.k8s.io/ingress-nginx/opentelemetry:v20230721-3e2062ee5 directly.";
    "io.nix-containers.upstream-image" = "registry.k8s.io/ingress-nginx/opentelemetry:v20230721-3e2062ee5";
    "io.nix-containers.image.upstream" = "registry.k8s.io/ingress-nginx/opentelemetry";
  };
}
