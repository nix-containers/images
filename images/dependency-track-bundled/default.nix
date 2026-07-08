{ nix2container, lib, pkgs, ... }:

# dependency-track-bundled — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/dependencytrack/bundled:4.14.2
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "dependency-track-bundled";
  tag = "4.14.2";
  config.Labels = {
    "org.opencontainers.image.version" = "4.14.2";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/dependencytrack/bundled:4.14.2 directly.";
    "io.nix-containers.upstream-image" = "docker.io/dependencytrack/bundled:4.14.2";
    "io.nix-containers.image.upstream" = "docker.io/dependencytrack/bundled";
  };
}
