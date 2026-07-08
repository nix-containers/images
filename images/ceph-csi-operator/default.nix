{ nix2container, lib, pkgs, ... }:

# ceph-csi-operator — UPSTREAM REFERENCE (not built/hosted). Use quay.io/cephcsi/ceph-csi-operator:v1.0.4 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "ceph-csi-operator";
  tag = "v1.0.4";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.0.4";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/cephcsi/ceph-csi-operator:v1.0.4 directly.";
    "io.nix-containers.upstream-image" = "quay.io/cephcsi/ceph-csi-operator:v1.0.4";
    "io.nix-containers.image.upstream" = "quay.io/cephcsi/ceph-csi-operator";
  };
}
