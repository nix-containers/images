{ nix2container, lib, pkgs, ... }:

# eks-distro-kube-scheduler — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: public.ecr.aws/eks-distro/kubernetes/kube-scheduler:v1.31.14-eks-1-31-41
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "eks-distro-kube-scheduler";
  tag = "v1.31.14-eks-1-31-41";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.31.14-eks-1-31-41";
    "org.opencontainers.image.description" = "Upstream reference — pull public.ecr.aws/eks-distro/kubernetes/kube-scheduler:v1.31.14-eks-1-31-41 directly.";
    "io.nix-containers.upstream-image" = "public.ecr.aws/eks-distro/kubernetes/kube-scheduler:v1.31.14-eks-1-31-41";
    "io.nix-containers.image.upstream" = "public.ecr.aws/eks-distro/kubernetes/kube-scheduler";
  };
}
