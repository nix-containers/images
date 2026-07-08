{ nix2container, lib, pkgs, ... }:

# kibana-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/library/kibana:9.4.3
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "kibana-fips";
  tag = "9.4.3";
  config.Labels = {
    "org.opencontainers.image.version" = "9.4.3";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/library/kibana:9.4.3 directly.";
    "io.nix-containers.upstream-image" = "docker.io/library/kibana:9.4.3";
    "io.nix-containers.image.upstream" = "docker.io/library/kibana";
  };
}
