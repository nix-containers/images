{ nix2container, lib, pkgs, ... }:

# mongodb-kubernetes-operator-version-upgrade-post-start-hook — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: quay.io/mongodb/mongodb-kubernetes-operator-version-upgrade-post-start-hook:1.0.9
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "mongodb-kubernetes-operator-version-upgrade-post-start-hook";
  tag = "1.0.9";
  config.Labels = {
    "org.opencontainers.image.version" = "1.0.9";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/mongodb/mongodb-kubernetes-operator-version-upgrade-post-start-hook:1.0.9 directly.";
    "io.nix-containers.upstream-image" = "quay.io/mongodb/mongodb-kubernetes-operator-version-upgrade-post-start-hook:1.0.9";
    "io.nix-containers.image.upstream" = "quay.io/mongodb/mongodb-kubernetes-operator-version-upgrade-post-start-hook";
  };
}
