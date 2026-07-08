{ nix2container, lib, pkgs, ... }:

# boky-postfix — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/boky/postfix:5.1.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "boky-postfix";
  tag = "5.1.0";
  config.Labels = {
    "org.opencontainers.image.version" = "5.1.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/boky/postfix:5.1.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/boky/postfix:5.1.0";
    "io.nix-containers.image.upstream" = "docker.io/boky/postfix";
  };
}
