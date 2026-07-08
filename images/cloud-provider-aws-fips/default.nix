{ nix2container, lib, pkgs, ... }:

# cloud-provider-aws-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: registry.k8s.io/provider-aws/cloud-controller-manager:v1.32.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "cloud-provider-aws-fips";
  tag = "v1.32.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.32.0";
    "org.opencontainers.image.description" = "Upstream reference — pull registry.k8s.io/provider-aws/cloud-controller-manager:v1.32.0 directly.";
    "io.nix-containers.upstream-image" = "registry.k8s.io/provider-aws/cloud-controller-manager:v1.32.0";
    "io.nix-containers.image.upstream" = "registry.k8s.io/provider-aws/cloud-controller-manager";
  };
}
