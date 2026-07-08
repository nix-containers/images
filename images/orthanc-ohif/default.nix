{ nix2container, lib, pkgs, ... }:

# orthanc-ohif — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/jodogne/orthanc:1.12.11
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "orthanc-ohif";
  tag = "1.12.11";
  config.Labels = {
    "org.opencontainers.image.version" = "1.12.11";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/jodogne/orthanc:1.12.11 directly.";
    "io.nix-containers.upstream-image" = "docker.io/jodogne/orthanc:1.12.11";
    "io.nix-containers.image.upstream" = "docker.io/jodogne/orthanc";
  };
}
