{ nix2container, lib, pkgs, ... }:

# keycloak-26.4-operator — UPSTREAM REFERENCE (not built/hosted). Use quay.io/keycloak/keycloak-operator:26.4.7 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "keycloak-26.4-operator";
  tag = "26.4.7";
  config.Labels = {
    "org.opencontainers.image.version" = "26.4.7";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/keycloak/keycloak-operator:26.4.7 directly.";
    "io.nix-containers.upstream-image" = "quay.io/keycloak/keycloak-operator:26.4.7";
    "io.nix-containers.image.upstream" = "quay.io/keycloak/keycloak-operator";
  };
}
