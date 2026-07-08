{ nix2container, lib, pkgs, ... }:

# redis-operator-fips — UPSTREAM REFERENCE (not built/hosted). Use quay.io/spotahome/redis-operator:v1.2.4 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "redis-operator-fips";
  tag = "v1.2.4";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.2.4";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/spotahome/redis-operator:v1.2.4 directly.";
    "io.nix-containers.upstream-image" = "quay.io/spotahome/redis-operator:v1.2.4";
    "io.nix-containers.image.upstream" = "quay.io/spotahome/redis-operator";
  };
}
