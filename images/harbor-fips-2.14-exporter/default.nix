{ nix2container, lib, pkgs, ... }:

# harbor-fips-2.14-exporter — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/goharbor/harbor-exporter:v2.15.2
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "harbor-fips-2.14-exporter";
  tag = "v2.15.2";
  config.Labels = {
    "org.opencontainers.image.version" = "v2.15.2";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/goharbor/harbor-exporter:v2.15.2 directly.";
    "io.nix-containers.upstream-image" = "docker.io/goharbor/harbor-exporter:v2.15.2";
    "io.nix-containers.image.upstream" = "docker.io/goharbor/harbor-exporter";
  };
}
