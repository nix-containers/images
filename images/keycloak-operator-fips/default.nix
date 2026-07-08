{ nix2container, lib, pkgs, ... }:

# keycloak-operator-fips — UPSTREAM REFERENCE (not built/hosted). Use quay.io/keycloak/keycloak-operator:26.6.4 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "keycloak-operator-fips";
  tag = "26.6.4";
  config.Labels = {
    "org.opencontainers.image.version" = "26.6.4";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/keycloak/keycloak-operator:26.6.4 directly.";
    "io.nix-containers.upstream-image" = "quay.io/keycloak/keycloak-operator:26.6.4";
    "io.nix-containers.image.upstream" = "quay.io/keycloak/keycloak-operator";
  };
}
