{ nix2container, lib, pkgs, ... }:

# graalvm-25-ce-default-jdk — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/graalvm/graalvm-community:20
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "graalvm-25-ce-default-jdk";
  tag = "20";
  config.Labels = {
    "org.opencontainers.image.version" = "20";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/graalvm/graalvm-community:20 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/graalvm/graalvm-community:20";
    "io.nix-containers.image.upstream" = "ghcr.io/graalvm/graalvm-community";
  };
}
