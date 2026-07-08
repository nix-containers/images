{ nix2container, lib, pkgs, ... }:

# python-3.13-privileged-netbindservice — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/library/python:3.13.14
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "python-3.13-privileged-netbindservice";
  tag = "3.13.14";
  config.Labels = {
    "org.opencontainers.image.version" = "3.13.14";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/library/python:3.13.14 directly.";
    "io.nix-containers.upstream-image" = "docker.io/library/python:3.13.14";
    "io.nix-containers.image.upstream" = "docker.io/library/python";
  };
}
