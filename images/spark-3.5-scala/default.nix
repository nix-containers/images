{ nix2container, lib, pkgs, ... }:

# spark-3.5-scala — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/apache/spark:3.5.8-scala
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "spark-3.5-scala";
  tag = "3.5.8-scala";
  config.Labels = {
    "org.opencontainers.image.version" = "3.5.8-scala";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/apache/spark:3.5.8-scala directly.";
    "io.nix-containers.upstream-image" = "docker.io/apache/spark:3.5.8-scala";
    "io.nix-containers.image.upstream" = "docker.io/apache/spark";
  };
}
