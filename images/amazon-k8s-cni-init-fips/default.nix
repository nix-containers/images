{ nix2container, lib, pkgs, ... }:

# amazon-k8s-cni-init-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: public.ecr.aws/eks/amazon-k8s-cni-init:v1.15.2
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "amazon-k8s-cni-init-fips";
  tag = "v1.15.2";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.15.2";
    "org.opencontainers.image.description" = "Upstream reference — pull public.ecr.aws/eks/amazon-k8s-cni-init:v1.15.2 directly.";
    "io.nix-containers.upstream-image" = "public.ecr.aws/eks/amazon-k8s-cni-init:v1.15.2";
    "io.nix-containers.image.upstream" = "public.ecr.aws/eks/amazon-k8s-cni-init";
  };
}
