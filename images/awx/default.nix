{ nix2container, lib, pkgs, ... }:

# awx — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: quay.io/ansible/awx:24.6.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "awx";
  tag = "24.6.1";
  config.Labels = {
    "org.opencontainers.image.version" = "24.6.1";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/ansible/awx:24.6.1 directly.";
    "io.nix-containers.upstream-image" = "quay.io/ansible/awx:24.6.1";
    "io.nix-containers.image.upstream" = "quay.io/ansible/awx";
  };
}
