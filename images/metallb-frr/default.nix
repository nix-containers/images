{ nix2container, lib, pkgs, ... }:

# metallb-frr — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/frrouting/frr:v8.4.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "metallb-frr";
  tag = "v8.4.1";
  config.Labels = {
    "org.opencontainers.image.version" = "v8.4.1";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/frrouting/frr:v8.4.1 directly.";
    "io.nix-containers.upstream-image" = "docker.io/frrouting/frr:v8.4.1";
    "io.nix-containers.image.upstream" = "docker.io/frrouting/frr";
  };
}
