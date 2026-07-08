{ nix2container, lib, pkgs, ... }:

# valkey-9.0-benchmark — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/valkey/valkey:9.0-trixie
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "valkey-9.0-benchmark";
  tag = "9.0-trixie";
  config.Labels = {
    "org.opencontainers.image.version" = "9.0-trixie";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/valkey/valkey:9.0-trixie directly.";
    "io.nix-containers.upstream-image" = "docker.io/valkey/valkey:9.0-trixie";
    "io.nix-containers.image.upstream" = "docker.io/valkey/valkey";
  };
}
