{ nix2container, lib, pkgs, ... }:

# katib-suggestion-pbt-enas — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/kubeflowkatib/suggestion-pbt:v1beta1-9caa8bc
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "katib-suggestion-pbt-enas";
  tag = "v1beta1-9caa8bc";
  config.Labels = {
    "org.opencontainers.image.version" = "v1beta1-9caa8bc";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/kubeflowkatib/suggestion-pbt:v1beta1-9caa8bc directly.";
    "io.nix-containers.upstream-image" = "docker.io/kubeflowkatib/suggestion-pbt:v1beta1-9caa8bc";
    "io.nix-containers.image.upstream" = "docker.io/kubeflowkatib/suggestion-pbt";
  };
}
