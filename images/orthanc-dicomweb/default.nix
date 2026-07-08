{ nix2container, lib, pkgs, ... }:

# orthanc-dicomweb — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/orthancteam/orthanc:26.6.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "orthanc-dicomweb";
  tag = "26.6.1";
  config.Labels = {
    "org.opencontainers.image.version" = "26.6.1";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/orthancteam/orthanc:26.6.1 directly.";
    "io.nix-containers.upstream-image" = "docker.io/orthancteam/orthanc:26.6.1";
    "io.nix-containers.image.upstream" = "docker.io/orthancteam/orthanc";
  };
}
