{ nix2container, lib, pkgs, ... }:

# dynamic-localpv-provisioner-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/openebs/provisioner-localpv:4.5.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "dynamic-localpv-provisioner-fips";
  tag = "4.5.1";
  config.Labels = {
    "org.opencontainers.image.version" = "4.5.1";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/openebs/provisioner-localpv:4.5.1 directly.";
    "io.nix-containers.upstream-image" = "docker.io/openebs/provisioner-localpv:4.5.1";
    "io.nix-containers.image.upstream" = "docker.io/openebs/provisioner-localpv";
  };
}
