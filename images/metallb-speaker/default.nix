{ nix2container, lib, pkgs, ... }:

# metallb-speaker — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: quay.io/metallb/speaker:v0.16.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "metallb-speaker";
  tag = "v0.16.1";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.16.1";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/metallb/speaker:v0.16.1 directly.";
    "io.nix-containers.upstream-image" = "quay.io/metallb/speaker:v0.16.1";
    "io.nix-containers.image.upstream" = "quay.io/metallb/speaker";
  };
}
