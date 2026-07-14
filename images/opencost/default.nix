{ nix2container, lib, pkgs, ... }:

# opencost — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/opencost/opencost:1.114.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "opencost";
  tag = "1.120.4";
  config.Labels = {
    "org.opencontainers.image.version" = "1.120.4";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/opencost/opencost:1.114.0 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/opencost/opencost:1.114.0";
    "io.nix-containers.image.upstream" = "ghcr.io/opencost/opencost";
  };
}
