{ nix2container, lib, pkgs, ... }:

# volcano-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/volcanosh/vc-scheduler:v1.15.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "volcano-fips";
  tag = "v1.15.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.15.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/volcanosh/vc-scheduler:v1.15.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/volcanosh/vc-scheduler:v1.15.0";
    "io.nix-containers.image.upstream" = "docker.io/volcanosh/vc-scheduler";
  };
}
