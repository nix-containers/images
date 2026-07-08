{ nix2container, lib, pkgs, ... }:

# tetragon-operator-fips — UPSTREAM REFERENCE (not built/hosted). Use quay.io/cilium/tetragon-operator:v1.7.0 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "tetragon-operator-fips";
  tag = "v1.7.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.7.0";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/cilium/tetragon-operator:v1.7.0 directly.";
    "io.nix-containers.upstream-image" = "quay.io/cilium/tetragon-operator:v1.7.0";
    "io.nix-containers.image.upstream" = "quay.io/cilium/tetragon-operator";
  };
}
