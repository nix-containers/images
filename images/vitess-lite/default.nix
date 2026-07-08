{ nix2container, lib, pkgs, ... }:

# vitess-lite — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/vitess/lite:v24.0.2
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "vitess-lite";
  tag = "v24.0.2";
  config.Labels = {
    "org.opencontainers.image.version" = "v24.0.2";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/vitess/lite:v24.0.2 directly.";
    "io.nix-containers.upstream-image" = "docker.io/vitess/lite:v24.0.2";
    "io.nix-containers.image.upstream" = "docker.io/vitess/lite";
  };
}
