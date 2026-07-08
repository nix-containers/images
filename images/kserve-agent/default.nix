{ nix2container, lib, pkgs, ... }:

# kserve-agent — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/kserve/agent:v0.19.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "kserve-agent";
  tag = "v0.19.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.19.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/kserve/agent:v0.19.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/kserve/agent:v0.19.0";
    "io.nix-containers.image.upstream" = "docker.io/kserve/agent";
  };
}
