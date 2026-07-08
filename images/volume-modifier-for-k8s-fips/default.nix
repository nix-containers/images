{ nix2container, lib, pkgs, ... }:

# volume-modifier-for-k8s-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: public.ecr.aws/ebs-csi-driver/volume-modifier-for-k8s:v0.9.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "volume-modifier-for-k8s-fips";
  tag = "v0.9.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.9.0";
    "org.opencontainers.image.description" = "Upstream reference — pull public.ecr.aws/ebs-csi-driver/volume-modifier-for-k8s:v0.9.0 directly.";
    "io.nix-containers.upstream-image" = "public.ecr.aws/ebs-csi-driver/volume-modifier-for-k8s:v0.9.0";
    "io.nix-containers.image.upstream" = "public.ecr.aws/ebs-csi-driver/volume-modifier-for-k8s";
  };
}
