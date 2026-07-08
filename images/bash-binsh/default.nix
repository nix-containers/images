{ nix2container, lib, pkgs, ... }:

# bash-binsh — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/library/bash:5.2.37
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "bash-binsh";
  tag = "5.2.37";
  config.Labels = {
    "org.opencontainers.image.version" = "5.2.37";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/library/bash:5.2.37 directly.";
    "io.nix-containers.upstream-image" = "docker.io/library/bash:5.2.37";
    "io.nix-containers.image.upstream" = "docker.io/library/bash";
  };
}
