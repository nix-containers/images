{ nix2container, lib, pkgs, ... }:

# karpenter-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: public.ecr.aws/karpenter/controller:v0.34.10
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "karpenter-fips";
  tag = "v0.34.10";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.34.10";
    "org.opencontainers.image.description" = "Upstream reference — pull public.ecr.aws/karpenter/controller:v0.34.10 directly.";
    "io.nix-containers.upstream-image" = "public.ecr.aws/karpenter/controller:v0.34.10";
    "io.nix-containers.image.upstream" = "public.ecr.aws/karpenter/controller";
  };
}
