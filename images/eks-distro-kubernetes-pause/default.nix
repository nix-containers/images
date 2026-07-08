{ nix2container, lib, pkgs, ... }:

# eks-distro-kubernetes-pause — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: public.ecr.aws/eks-distro/kubernetes/pause:v1.33.5-eks-1-33-20
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "eks-distro-kubernetes-pause";
  tag = "v1.33.5-eks-1-33-20";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.33.5-eks-1-33-20";
    "org.opencontainers.image.description" = "Upstream reference — pull public.ecr.aws/eks-distro/kubernetes/pause:v1.33.5-eks-1-33-20 directly.";
    "io.nix-containers.upstream-image" = "public.ecr.aws/eks-distro/kubernetes/pause:v1.33.5-eks-1-33-20";
    "io.nix-containers.image.upstream" = "public.ecr.aws/eks-distro/kubernetes/pause";
  };
}
