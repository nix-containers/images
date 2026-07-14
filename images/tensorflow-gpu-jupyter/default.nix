{ nix2container, lib, pkgs, ... }:

# tensorflow-gpu-jupyter — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/tensorflow/tensorflow:2.21.0-gpu-jupyter
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "tensorflow-gpu-jupyter";
  tag = "2.21.0";
  config.Labels = {
    "org.opencontainers.image.version" = "2.21.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/tensorflow/tensorflow:2.21.0-gpu-jupyter directly.";
    "io.nix-containers.upstream-image" = "docker.io/tensorflow/tensorflow:2.21.0-gpu-jupyter";
    "io.nix-containers.image.upstream" = "docker.io/tensorflow/tensorflow";
  };
}
