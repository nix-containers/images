{ nix2container, lib, pkgs, ... }:

# tigera-operator-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: quay.io/tigera/operator:v1.42.4
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "tigera-operator-fips";
  tag = "v1.42.4";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.42.4";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/tigera/operator:v1.42.4 directly.";
    "io.nix-containers.upstream-image" = "quay.io/tigera/operator:v1.42.4";
    "io.nix-containers.image.upstream" = "quay.io/tigera/operator";
  };
}
