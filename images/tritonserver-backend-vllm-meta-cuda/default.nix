{ nix2container, lib, pkgs, ... }:

# tritonserver-backend-vllm-meta-cuda — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: nvcr.io/nvidia/tritonserver:26.06-vllm-python-py3
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "tritonserver-backend-vllm-meta-cuda";
  tag = "26.06-vllm-python-py3";
  config.Labels = {
    "org.opencontainers.image.version" = "26.06-vllm-python-py3";
    "org.opencontainers.image.description" = "Upstream reference — pull nvcr.io/nvidia/tritonserver:26.06-vllm-python-py3 directly.";
    "io.nix-containers.upstream-image" = "nvcr.io/nvidia/tritonserver:26.06-vllm-python-py3";
    "io.nix-containers.image.upstream" = "nvcr.io/nvidia/tritonserver";
  };
}
