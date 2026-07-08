{ nix2container, lib, pkgs, ... }:

# secrets-store-csi-driver — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: registry.k8s.io/csi-secrets-store/driver:v1.6.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "secrets-store-csi-driver";
  tag = "v1.6.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.6.0";
    "org.opencontainers.image.description" = "Upstream reference — pull registry.k8s.io/csi-secrets-store/driver:v1.6.0 directly.";
    "io.nix-containers.upstream-image" = "registry.k8s.io/csi-secrets-store/driver:v1.6.0";
    "io.nix-containers.image.upstream" = "registry.k8s.io/csi-secrets-store/driver";
  };
}
