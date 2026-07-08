{ nix2container, lib, pkgs, ... }:

# argocd-extension-installer-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: quay.io/argoprojlabs/argocd-extension-installer:v1.0.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "argocd-extension-installer-fips";
  tag = "v1.0.1";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.0.1";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/argoprojlabs/argocd-extension-installer:v1.0.1 directly.";
    "io.nix-containers.upstream-image" = "quay.io/argoprojlabs/argocd-extension-installer:v1.0.1";
    "io.nix-containers.image.upstream" = "quay.io/argoprojlabs/argocd-extension-installer";
  };
}
