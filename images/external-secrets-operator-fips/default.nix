{ nix2container, lib, pkgs, ... }:

# external-secrets-operator-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/external-secrets/external-secrets:v0.5.5
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "external-secrets-operator-fips";
  tag = "v0.5.5";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.5.5";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/external-secrets/external-secrets:v0.5.5 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/external-secrets/external-secrets:v0.5.5";
    "io.nix-containers.image.upstream" = "ghcr.io/external-secrets/external-secrets";
  };
}
