{ nix2container, lib, pkgs, ... }:

# volsync-fips-diskrsync-tcp — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: quay.io/backube/volsync:0.16.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "volsync-fips-diskrsync-tcp";
  tag = "0.16.0";
  config.Labels = {
    "org.opencontainers.image.version" = "0.16.0";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/backube/volsync:0.16.0 directly.";
    "io.nix-containers.upstream-image" = "quay.io/backube/volsync:0.16.0";
    "io.nix-containers.image.upstream" = "quay.io/backube/volsync";
  };
}
