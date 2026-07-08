{ nix2container, lib, pkgs, ... }:

# apache-apisix — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/apache/apisix:3.17.0-debian
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "apache-apisix";
  tag = "3.17.0-debian";
  config.Labels = {
    "org.opencontainers.image.version" = "3.17.0-debian";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/apache/apisix:3.17.0-debian directly.";
    "io.nix-containers.upstream-image" = "docker.io/apache/apisix:3.17.0-debian";
    "io.nix-containers.image.upstream" = "docker.io/apache/apisix";
  };
}
