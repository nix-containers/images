{ nix2container, lib, pkgs, ... }:

# trust-manager-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: quay.io/jetstack/trust-manager:v0.24.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "trust-manager-fips";
  tag = "v0.24.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.24.0";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/jetstack/trust-manager:v0.24.0 directly.";
    "io.nix-containers.upstream-image" = "quay.io/jetstack/trust-manager:v0.24.0";
    "io.nix-containers.image.upstream" = "quay.io/jetstack/trust-manager";
  };
}
