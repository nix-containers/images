{ nix2container, lib, pkgs, ... }:

# ratify-schemavalidator — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/ratify-project/ratify:v1.4.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "ratify-schemavalidator";
  tag = "v1.4.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.4.0";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/ratify-project/ratify:v1.4.0 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/ratify-project/ratify:v1.4.0";
    "io.nix-containers.image.upstream" = "ghcr.io/ratify-project/ratify";
  };
}
