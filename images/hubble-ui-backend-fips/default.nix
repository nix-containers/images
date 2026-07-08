{ nix2container, lib, pkgs, ... }:

# hubble-ui-backend-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: quay.io/cilium/hubble-ui-backend:v0.13.5
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "hubble-ui-backend-fips";
  tag = "v0.13.5";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.13.5";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/cilium/hubble-ui-backend:v0.13.5 directly.";
    "io.nix-containers.upstream-image" = "quay.io/cilium/hubble-ui-backend:v0.13.5";
    "io.nix-containers.image.upstream" = "quay.io/cilium/hubble-ui-backend";
  };
}
