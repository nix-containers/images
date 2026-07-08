{ nix2container, lib, pkgs, ... }:

# sealed-secrets-controller — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/bitnami/sealed-secrets-controller:0.38.4
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "sealed-secrets-controller";
  tag = "0.38.4";
  config.Labels = {
    "org.opencontainers.image.version" = "0.38.4";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/bitnami/sealed-secrets-controller:0.38.4 directly.";
    "io.nix-containers.upstream-image" = "docker.io/bitnami/sealed-secrets-controller:0.38.4";
    "io.nix-containers.image.upstream" = "docker.io/bitnami/sealed-secrets-controller";
  };
}
