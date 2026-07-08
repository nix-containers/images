{ nix2container, lib, pkgs, ... }:

# vault-secrets-operator — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/hashicorp/vault-secrets-operator:1.4.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "vault-secrets-operator";
  tag = "1.4.1";
  config.Labels = {
    "org.opencontainers.image.version" = "1.4.1";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/hashicorp/vault-secrets-operator:1.4.1 directly.";
    "io.nix-containers.upstream-image" = "docker.io/hashicorp/vault-secrets-operator:1.4.1";
    "io.nix-containers.image.upstream" = "docker.io/hashicorp/vault-secrets-operator";
  };
}
