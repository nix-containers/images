{ nix2container, lib, pkgs, ... }:

# tomcat-11.0-openjdk — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/library/tomcat:11.0.24-jre21-temurin
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "tomcat-11.0-openjdk";
  tag = "11.0.24-jre21-temurin";
  config.Labels = {
    "org.opencontainers.image.version" = "11.0.24-jre21-temurin";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/library/tomcat:11.0.24-jre21-temurin directly.";
    "io.nix-containers.upstream-image" = "docker.io/library/tomcat:11.0.24-jre21-temurin";
    "io.nix-containers.image.upstream" = "docker.io/library/tomcat";
  };
}
