{ nix2container, lib, pkgs, ... }:

# openssh-server-fips — UPSTREAM REFERENCE (not built/hosted). Use docker.io/linuxserver/openssh-server:version-10.3_p1-r0 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "openssh-server-fips";
  tag = "version-10.3_p1-r0";
  config.Labels = {
    "org.opencontainers.image.version" = "version-10.3_p1-r0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/linuxserver/openssh-server:version-10.3_p1-r0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/linuxserver/openssh-server:version-10.3_p1-r0";
    "io.nix-containers.image.upstream" = "docker.io/linuxserver/openssh-server";
  };
}
