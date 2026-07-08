{ nix2container, lib, pkgs, ... }:

# efs-utils — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/amazon/aws-efs-csi-driver:v2.1.4
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "efs-utils";
  tag = "v2.1.4";
  config.Labels = {
    "org.opencontainers.image.version" = "v2.1.4";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/amazon/aws-efs-csi-driver:v2.1.4 directly.";
    "io.nix-containers.upstream-image" = "docker.io/amazon/aws-efs-csi-driver:v2.1.4";
    "io.nix-containers.image.upstream" = "docker.io/amazon/aws-efs-csi-driver";
  };
}
