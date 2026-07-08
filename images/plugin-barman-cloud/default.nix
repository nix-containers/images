{ nix2container, lib, pkgs, ... }:

# plugin-barman-cloud — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/cloudnative-pg/plugin-barman-cloud:v0.13.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "plugin-barman-cloud";
  tag = "v0.13.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.13.0";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/cloudnative-pg/plugin-barman-cloud:v0.13.0 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/cloudnative-pg/plugin-barman-cloud:v0.13.0";
    "io.nix-containers.image.upstream" = "ghcr.io/cloudnative-pg/plugin-barman-cloud";
  };
}
