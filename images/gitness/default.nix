{ nix2container, lib, pkgs, ... }:

# gitness — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/harness/gitness:release-27
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "gitness";
  tag = "release-27";
  config.Labels = {
    "org.opencontainers.image.version" = "release-27";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/harness/gitness:release-27 directly.";
    "io.nix-containers.upstream-image" = "docker.io/harness/gitness:release-27";
    "io.nix-containers.image.upstream" = "docker.io/harness/gitness";
  };
}
