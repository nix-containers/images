{ nix2container, lib, pkgs, ... }:

# vault-csi-provider-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/hashicorp/vault-csi-provider:1.7.3
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "vault-csi-provider-fips";
  tag = "1.7.3";
  config.Labels = {
    "org.opencontainers.image.version" = "1.7.3";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/hashicorp/vault-csi-provider:1.7.3 directly.";
    "io.nix-containers.upstream-image" = "docker.io/hashicorp/vault-csi-provider:1.7.3";
    "io.nix-containers.image.upstream" = "docker.io/hashicorp/vault-csi-provider";
  };
}
