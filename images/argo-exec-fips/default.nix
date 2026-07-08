{ nix2container, lib, pkgs, ... }:

# argo-exec-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: quay.io/argoproj/argoexec:v4.0.7
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "argo-exec-fips";
  tag = "v4.0.7";
  config.Labels = {
    "org.opencontainers.image.version" = "v4.0.7";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/argoproj/argoexec:v4.0.7 directly.";
    "io.nix-containers.upstream-image" = "quay.io/argoproj/argoexec:v4.0.7";
    "io.nix-containers.image.upstream" = "quay.io/argoproj/argoexec";
  };
}
