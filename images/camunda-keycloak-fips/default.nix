{ nix2container, lib, pkgs, ... }:

# camunda-keycloak-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/camunda/keycloak:26.3.3
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "camunda-keycloak-fips";
  tag = "26.3.3";
  config.Labels = {
    "org.opencontainers.image.version" = "26.3.3";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/camunda/keycloak:26.3.3 directly.";
    "io.nix-containers.upstream-image" = "docker.io/camunda/keycloak:26.3.3";
    "io.nix-containers.image.upstream" = "docker.io/camunda/keycloak";
  };
}
