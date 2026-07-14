{ nix2container, lib, pkgs, ... }:

# neuvector-manager-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/neuvector/manager:5.5.3
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "neuvector-manager-fips";
  tag = "8241.2";
  config.Labels = {
    "org.opencontainers.image.version" = "8241.2";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/neuvector/manager:5.5.3 directly.";
    "io.nix-containers.upstream-image" = "docker.io/neuvector/manager:5.5.3";
    "io.nix-containers.image.upstream" = "docker.io/neuvector/manager";
  };
}
