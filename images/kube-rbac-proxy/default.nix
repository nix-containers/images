{ nix2container, lib, pkgs, ... }:

# kube-rbac-proxy — UPSTREAM REFERENCE (not built/hosted). Use quay.io/brancz/kube-rbac-proxy:v0.9.0 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "kube-rbac-proxy";
  tag = "v0.9.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.9.0";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/brancz/kube-rbac-proxy:v0.9.0 directly.";
    "io.nix-containers.upstream-image" = "quay.io/brancz/kube-rbac-proxy:v0.9.0";
    "io.nix-containers.image.upstream" = "quay.io/brancz/kube-rbac-proxy";
  };
}
