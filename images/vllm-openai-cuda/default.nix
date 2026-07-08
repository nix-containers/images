{ nix2container, lib, pkgs, ... }:

# vllm-openai-cuda — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/vllm/vllm-openai:v0.24.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "vllm-openai-cuda";
  tag = "v0.24.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.24.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/vllm/vllm-openai:v0.24.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/vllm/vllm-openai:v0.24.0";
    "io.nix-containers.image.upstream" = "docker.io/vllm/vllm-openai";
  };
}
