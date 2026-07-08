{ nix2container, lib, pkgs, ... }:

# ingress-nginx-custom-error-pages-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: quay.io/kubernetes-ingress-controller/custom-error-pages:0.4
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "ingress-nginx-custom-error-pages-fips";
  tag = "0.4";
  config.Labels = {
    "org.opencontainers.image.version" = "0.4";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/kubernetes-ingress-controller/custom-error-pages:0.4 directly.";
    "io.nix-containers.upstream-image" = "quay.io/kubernetes-ingress-controller/custom-error-pages:0.4";
    "io.nix-containers.image.upstream" = "quay.io/kubernetes-ingress-controller/custom-error-pages";
  };
}
