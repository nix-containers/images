{ nix2container, lib, pkgs, ... }:

# smarter-device-manager-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: registry.gitlab.com/arm-research/smarter/smarter-device-manager:v1.20.11
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "smarter-device-manager-fips";
  tag = "v1.20.11";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.20.11";
    "org.opencontainers.image.description" = "Upstream reference — pull registry.gitlab.com/arm-research/smarter/smarter-device-manager:v1.20.11 directly.";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/arm-research/smarter/smarter-device-manager:v1.20.11";
    "io.nix-containers.image.upstream" = "registry.gitlab.com/arm-research/smarter/smarter-device-manager";
  };
}
