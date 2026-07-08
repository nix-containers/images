{ nix2container, lib, pkgs, ... }:

# opencost-ui-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/opencost/opencost-ui:1.116.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "opencost-ui-fips";
  tag = "1.116.0";
  config.Labels = {
    "org.opencontainers.image.version" = "1.116.0";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/opencost/opencost-ui:1.116.0 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/opencost/opencost-ui:1.116.0";
    "io.nix-containers.image.upstream" = "ghcr.io/opencost/opencost-ui";
  };
}
