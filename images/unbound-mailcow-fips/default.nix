{ nix2container, lib, pkgs, ... }:

# unbound-mailcow-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/mailcow/unbound:1.23
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "unbound-mailcow-fips";
  tag = "1.23";
  config.Labels = {
    "org.opencontainers.image.version" = "1.23";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/mailcow/unbound:1.23 directly.";
    "io.nix-containers.upstream-image" = "docker.io/mailcow/unbound:1.23";
    "io.nix-containers.image.upstream" = "docker.io/mailcow/unbound";
  };
}
