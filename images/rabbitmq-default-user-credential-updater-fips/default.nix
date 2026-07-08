{ nix2container, lib, pkgs, ... }:

# rabbitmq-default-user-credential-updater-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/rabbitmqoperator/default-user-credential-updater:1.0.13
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "rabbitmq-default-user-credential-updater-fips";
  tag = "1.0.13";
  config.Labels = {
    "org.opencontainers.image.version" = "1.0.13";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/rabbitmqoperator/default-user-credential-updater:1.0.13 directly.";
    "io.nix-containers.upstream-image" = "docker.io/rabbitmqoperator/default-user-credential-updater:1.0.13";
    "io.nix-containers.image.upstream" = "docker.io/rabbitmqoperator/default-user-credential-updater";
  };
}
