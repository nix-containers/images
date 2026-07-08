{ nix2container, lib, pkgs, ... }:

# erl27-elixir — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/library/elixir:otp-27
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "erl27-elixir";
  tag = "otp-27";
  config.Labels = {
    "org.opencontainers.image.version" = "otp-27";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/library/elixir:otp-27 directly.";
    "io.nix-containers.upstream-image" = "docker.io/library/elixir:otp-27";
    "io.nix-containers.image.upstream" = "docker.io/library/elixir";
  };
}
