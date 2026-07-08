{ nix2container, lib, pkgs, ... }:

# valkey-9.0-cli — UPSTREAM REFERENCE (not built/hosted). Use docker.io/valkey/valkey:9.0.4 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "valkey-9.0-cli";
  tag = "9.0.4";
  config.Labels = {
    "org.opencontainers.image.version" = "9.0.4";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/valkey/valkey:9.0.4 directly.";
    "io.nix-containers.upstream-image" = "docker.io/valkey/valkey:9.0.4";
    "io.nix-containers.image.upstream" = "docker.io/valkey/valkey";
  };
}
