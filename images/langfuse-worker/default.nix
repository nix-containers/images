{ nix2container, lib, pkgs, ... }:

# langfuse-worker — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/langfuse/langfuse-worker:3.208.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "langfuse-worker";
  tag = "3.208.0";
  config.Labels = {
    "org.opencontainers.image.version" = "3.208.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/langfuse/langfuse-worker:3.208.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/langfuse/langfuse-worker:3.208.0";
    "io.nix-containers.image.upstream" = "docker.io/langfuse/langfuse-worker";
  };
}
