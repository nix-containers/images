{ nix2container, lib, pkgs, ... }:

# thingsboard-tb-mqtt-transport — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/thingsboard/tb-mqtt-transport:4.3.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "thingsboard-tb-mqtt-transport";
  tag = "4.3.1";
  config.Labels = {
    "org.opencontainers.image.version" = "4.3.1";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/thingsboard/tb-mqtt-transport:4.3.1 directly.";
    "io.nix-containers.upstream-image" = "docker.io/thingsboard/tb-mqtt-transport:4.3.1";
    "io.nix-containers.image.upstream" = "docker.io/thingsboard/tb-mqtt-transport";
  };
}
