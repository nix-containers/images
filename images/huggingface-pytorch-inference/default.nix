{ nix2container, lib, pkgs, ... }:

# huggingface-pytorch-inference — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/huggingface/transformers-pytorch-gpu:4.41.3
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "huggingface-pytorch-inference";
  tag = "4.41.3";
  config.Labels = {
    "org.opencontainers.image.version" = "4.41.3";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/huggingface/transformers-pytorch-gpu:4.41.3 directly.";
    "io.nix-containers.upstream-image" = "docker.io/huggingface/transformers-pytorch-gpu:4.41.3";
    "io.nix-containers.image.upstream" = "docker.io/huggingface/transformers-pytorch-gpu";
  };
}
