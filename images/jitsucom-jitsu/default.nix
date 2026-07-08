{ nix2container, lib, pkgs, ... }:

# jitsucom-jitsu — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/jitsucom/jitsu:1.44.8
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "jitsucom-jitsu";
  tag = "1.44.8";
  config.Labels = {
    "org.opencontainers.image.version" = "1.44.8";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/jitsucom/jitsu:1.44.8 directly.";
    "io.nix-containers.upstream-image" = "docker.io/jitsucom/jitsu:1.44.8";
    "io.nix-containers.image.upstream" = "docker.io/jitsucom/jitsu";
  };
}
