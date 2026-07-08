{ nix2container, lib, pkgs, ... }:

# airflow-core — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/apache/airflow:3.3.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "airflow-core";
  tag = "3.3.0";
  config.Labels = {
    "org.opencontainers.image.version" = "3.3.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/apache/airflow:3.3.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/apache/airflow:3.3.0";
    "io.nix-containers.image.upstream" = "docker.io/apache/airflow";
  };
}
