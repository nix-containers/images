{ nix2container, lib, pkgs, ... }:

# pgpool2-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/pgpool/pgpool:4.4.3
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "pgpool2-fips";
  tag = "4.4.3";
  config.Labels = {
    "org.opencontainers.image.version" = "4.4.3";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/pgpool/pgpool:4.4.3 directly.";
    "io.nix-containers.upstream-image" = "docker.io/pgpool/pgpool:4.4.3";
    "io.nix-containers.image.upstream" = "docker.io/pgpool/pgpool";
  };
}
