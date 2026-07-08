{ nix2container, lib, pkgs, ... }:

# selenium-server — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/selenium/hub:4.45.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "selenium-server";
  tag = "4.45.0";
  config.Labels = {
    "org.opencontainers.image.version" = "4.45.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/selenium/hub:4.45.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/selenium/hub:4.45.0";
    "io.nix-containers.image.upstream" = "docker.io/selenium/hub";
  };
}
