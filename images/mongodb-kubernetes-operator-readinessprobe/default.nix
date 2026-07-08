{ nix2container, lib, pkgs, ... }:

# mongodb-kubernetes-operator-readinessprobe — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: quay.io/mongodb/mongodb-kubernetes-readinessprobe:1.0.24
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "mongodb-kubernetes-operator-readinessprobe";
  tag = "1.0.24";
  config.Labels = {
    "org.opencontainers.image.version" = "1.0.24";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/mongodb/mongodb-kubernetes-readinessprobe:1.0.24 directly.";
    "io.nix-containers.upstream-image" = "quay.io/mongodb/mongodb-kubernetes-readinessprobe:1.0.24";
    "io.nix-containers.image.upstream" = "quay.io/mongodb/mongodb-kubernetes-readinessprobe";
  };
}
