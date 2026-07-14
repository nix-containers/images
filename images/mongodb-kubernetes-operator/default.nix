{ nix2container, lib, pkgs, ... }:

# mongodb-kubernetes-operator — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: quay.io/mongodb/mongodb-kubernetes-operator:0.9.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "mongodb-kubernetes-operator";
  tag = "0.13.0";
  config.Labels = {
    "org.opencontainers.image.version" = "0.13.0";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/mongodb/mongodb-kubernetes-operator:0.9.0 directly.";
    "io.nix-containers.upstream-image" = "quay.io/mongodb/mongodb-kubernetes-operator:0.9.0";
    "io.nix-containers.image.upstream" = "quay.io/mongodb/mongodb-kubernetes-operator";
  };
}
