{ nix2container, lib, pkgs, ... }:

# text-generation-inference — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/huggingface/text-generation-inference:0.9.4
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "text-generation-inference";
  tag = "0.9.4";
  config.Labels = {
    "org.opencontainers.image.version" = "0.9.4";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/huggingface/text-generation-inference:0.9.4 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/huggingface/text-generation-inference:0.9.4";
    "io.nix-containers.image.upstream" = "ghcr.io/huggingface/text-generation-inference";
  };
}
