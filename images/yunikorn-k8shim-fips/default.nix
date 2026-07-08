{ nix2container, lib, pkgs, ... }:

# yunikorn-k8shim-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/apache/yunikorn:scheduler-1.8.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "yunikorn-k8shim-fips";
  tag = "scheduler-1.8.0";
  config.Labels = {
    "org.opencontainers.image.version" = "scheduler-1.8.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/apache/yunikorn:scheduler-1.8.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/apache/yunikorn:scheduler-1.8.0";
    "io.nix-containers.image.upstream" = "docker.io/apache/yunikorn";
  };
}
