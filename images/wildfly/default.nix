{ nix2container, lib, pkgs, ... }:

# wildfly — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: quay.io/wildfly/wildfly:40.0.1.Final-jdk21
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "wildfly";
  tag = "40.0.1.Final-jdk21";
  config.Labels = {
    "org.opencontainers.image.version" = "40.0.1.Final-jdk21";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/wildfly/wildfly:40.0.1.Final-jdk21 directly.";
    "io.nix-containers.upstream-image" = "quay.io/wildfly/wildfly:40.0.1.Final-jdk21";
    "io.nix-containers.image.upstream" = "quay.io/wildfly/wildfly";
  };
}
