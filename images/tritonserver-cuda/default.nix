{ nix2container, lib, pkgs, ... }:

# tritonserver-cuda — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: nvcr.io/nvidia/tritonserver:26.06-py3
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "tritonserver-cuda";
  tag = "26.06-py3";
  config.Labels = {
    "org.opencontainers.image.version" = "26.06-py3";
    "org.opencontainers.image.description" = "Upstream reference — pull nvcr.io/nvidia/tritonserver:26.06-py3 directly.";
    "io.nix-containers.upstream-image" = "nvcr.io/nvidia/tritonserver:26.06-py3";
    "io.nix-containers.image.upstream" = "nvcr.io/nvidia/tritonserver";
  };
}
