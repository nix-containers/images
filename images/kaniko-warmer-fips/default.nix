{ nix2container, lib, pkgs, ... }:

# kaniko-warmer-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: gcr.io/kaniko-project/warmer:v1.19.2
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "kaniko-warmer-fips";
  tag = "v1.19.2";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.19.2";
    "org.opencontainers.image.description" = "Upstream reference — pull gcr.io/kaniko-project/warmer:v1.19.2 directly.";
    "io.nix-containers.upstream-image" = "gcr.io/kaniko-project/warmer:v1.19.2";
    "io.nix-containers.image.upstream" = "gcr.io/kaniko-project/warmer";
  };
}
