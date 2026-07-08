{ nix2container, lib, pkgs, ... }:

# policy-controller — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/sigstore/policy-controller/policy-controller:v0.9.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "policy-controller";
  tag = "v0.9.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.9.0";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/sigstore/policy-controller/policy-controller:v0.9.0 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/sigstore/policy-controller/policy-controller:v0.9.0";
    "io.nix-containers.image.upstream" = "ghcr.io/sigstore/policy-controller/policy-controller";
  };
}
