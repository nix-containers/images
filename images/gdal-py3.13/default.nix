{ nix2container, lib, pkgs, ... }:

# gdal-py3.13 — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/osgeo/gdal:ubuntu-full-3.6.3
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "gdal-py3.13";
  tag = "ubuntu-full-3.6.3";
  config.Labels = {
    "org.opencontainers.image.version" = "ubuntu-full-3.6.3";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/osgeo/gdal:ubuntu-full-3.6.3 directly.";
    "io.nix-containers.upstream-image" = "docker.io/osgeo/gdal:ubuntu-full-3.6.3";
    "io.nix-containers.image.upstream" = "docker.io/osgeo/gdal";
  };
}
