{ nix2container, lib, pkgs, ... }:

# playwright-headed — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: mcr.microsoft.com/playwright:v1.49.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "playwright-headed";
  tag = "v1.49.1";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.49.1";
    "org.opencontainers.image.description" = "Upstream reference — pull mcr.microsoft.com/playwright:v1.49.1 directly.";
    "io.nix-containers.upstream-image" = "mcr.microsoft.com/playwright:v1.49.1";
    "io.nix-containers.image.upstream" = "mcr.microsoft.com/playwright";
  };
}
