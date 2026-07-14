{ nix2container, lib, pkgs, ... }:

# erl27-rebar3 — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/library/erlang:27.3.4.14
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "erl27-rebar3";
  tag = "29.0.3";
  config.Labels = {
    "org.opencontainers.image.version" = "29.0.3";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/library/erlang:27.3.4.14 directly.";
    "io.nix-containers.upstream-image" = "docker.io/library/erlang:27.3.4.14";
    "io.nix-containers.image.upstream" = "docker.io/library/erlang";
  };
}
