{ nix2container, lib, pkgs, ... }:

# velero-plugin-for-microsoft-azure — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/velero/velero-plugin-for-microsoft-azure:v1.14.2
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "velero-plugin-for-microsoft-azure";
  tag = "v1.14.2";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.14.2";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/velero/velero-plugin-for-microsoft-azure:v1.14.2 directly.";
    "io.nix-containers.upstream-image" = "docker.io/velero/velero-plugin-for-microsoft-azure:v1.14.2";
    "io.nix-containers.image.upstream" = "docker.io/velero/velero-plugin-for-microsoft-azure";
  };
}
