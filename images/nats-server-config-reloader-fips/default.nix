{ nix2container, lib, pkgs, ... }:

# nats-server-config-reloader-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/natsio/nats-server-config-reloader:0.23.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "nats-server-config-reloader-fips";
  tag = "0.23.0";
  config.Labels = {
    "org.opencontainers.image.version" = "0.23.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/natsio/nats-server-config-reloader:0.23.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/natsio/nats-server-config-reloader:0.23.0";
    "io.nix-containers.image.upstream" = "docker.io/natsio/nats-server-config-reloader";
  };
}
