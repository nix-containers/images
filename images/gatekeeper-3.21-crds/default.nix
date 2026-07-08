{ nix2container, lib, pkgs, ... }:

# gatekeeper-3.21-crds — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/openpolicyagent/gatekeeper:v3.21.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "gatekeeper-3.21-crds";
  tag = "v3.21.1";
  config.Labels = {
    "org.opencontainers.image.version" = "v3.21.1";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/openpolicyagent/gatekeeper:v3.21.1 directly.";
    "io.nix-containers.upstream-image" = "docker.io/openpolicyagent/gatekeeper:v3.21.1";
    "io.nix-containers.image.upstream" = "docker.io/openpolicyagent/gatekeeper";
  };
}
