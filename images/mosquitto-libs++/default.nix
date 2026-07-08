{ nix2container, lib, pkgs, ... }:

# mosquitto-libs++ — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/library/eclipse-mosquitto:2.0.22
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "mosquitto-libs++";
  tag = "2.0.22";
  config.Labels = {
    "org.opencontainers.image.version" = "2.0.22";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/library/eclipse-mosquitto:2.0.22 directly.";
    "io.nix-containers.upstream-image" = "docker.io/library/eclipse-mosquitto:2.0.22";
    "io.nix-containers.image.upstream" = "docker.io/library/eclipse-mosquitto";
  };
}
