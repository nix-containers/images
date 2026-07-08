{ nix2container, lib, pkgs, ... }:

# gatekeeper-crds-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/openpolicyagent/gatekeeper:v3.22.2
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "gatekeeper-crds-fips";
  tag = "v3.22.2";
  config.Labels = {
    "org.opencontainers.image.version" = "v3.22.2";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/openpolicyagent/gatekeeper:v3.22.2 directly.";
    "io.nix-containers.upstream-image" = "docker.io/openpolicyagent/gatekeeper:v3.22.2";
    "io.nix-containers.image.upstream" = "docker.io/openpolicyagent/gatekeeper";
  };
}
