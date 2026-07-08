{ nix2container, lib, pkgs, ... }:

# kiam — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/uswitch/kiam:v1.2.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "kiam";
  tag = "v1.2.1";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.2.1";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/uswitch/kiam:v1.2.1 directly.";
    "io.nix-containers.upstream-image" = "docker.io/uswitch/kiam:v1.2.1";
    "io.nix-containers.image.upstream" = "docker.io/uswitch/kiam";
  };
}
