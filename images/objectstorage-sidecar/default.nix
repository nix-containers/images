{ nix2container, lib, pkgs, ... }:

# objectstorage-sidecar — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: registry.k8s.io/sig-storage/objectstorage-sidecar:v0.2.2
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "objectstorage-sidecar";
  tag = "v0.2.2";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.2.2";
    "org.opencontainers.image.description" = "Upstream reference — pull registry.k8s.io/sig-storage/objectstorage-sidecar:v0.2.2 directly.";
    "io.nix-containers.upstream-image" = "registry.k8s.io/sig-storage/objectstorage-sidecar:v0.2.2";
    "io.nix-containers.image.upstream" = "registry.k8s.io/sig-storage/objectstorage-sidecar";
  };
}
