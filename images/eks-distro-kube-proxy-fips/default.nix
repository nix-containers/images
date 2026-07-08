{ nix2container, lib, pkgs, ... }:

# eks-distro-kube-proxy-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: public.ecr.aws/eks-distro/kubernetes/kube-proxy:v1.30.5-eks-1-30-17
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "eks-distro-kube-proxy-fips";
  tag = "v1.30.5-eks-1-30-17";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.30.5-eks-1-30-17";
    "org.opencontainers.image.description" = "Upstream reference — pull public.ecr.aws/eks-distro/kubernetes/kube-proxy:v1.30.5-eks-1-30-17 directly.";
    "io.nix-containers.upstream-image" = "public.ecr.aws/eks-distro/kubernetes/kube-proxy:v1.30.5-eks-1-30-17";
    "io.nix-containers.image.upstream" = "public.ecr.aws/eks-distro/kubernetes/kube-proxy";
  };
}
