{ nix2container, lib, pkgs, ... }:

# thanos-operator-fips — UPSTREAM REFERENCE (not built/hosted). Use quay.io/thanos/thanos-operator:latest directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "thanos-operator-fips";
  tag = "latest";
  config.Labels = {
    "org.opencontainers.image.version" = "latest";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/thanos/thanos-operator:latest directly.";
    "io.nix-containers.upstream-image" = "quay.io/thanos/thanos-operator:latest";
    "io.nix-containers.image.upstream" = "quay.io/thanos/thanos-operator";
  };
}
