{ nix2container, lib, pkgs, ... }:

# erl28-elixir — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/library/elixir:otp-28
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "erl28-elixir";
  tag = "otp-28";
  config.Labels = {
    "org.opencontainers.image.version" = "otp-28";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/library/elixir:otp-28 directly.";
    "io.nix-containers.upstream-image" = "docker.io/library/elixir:otp-28";
    "io.nix-containers.image.upstream" = "docker.io/library/elixir";
  };
}
