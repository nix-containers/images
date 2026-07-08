{ nix2container, lib, pkgs, ... }:

# vertical-pod-autoscaler-recommender — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: registry.k8s.io/autoscaling/vpa-recommender:1.7.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "vertical-pod-autoscaler-recommender";
  tag = "1.7.0";
  config.Labels = {
    "org.opencontainers.image.version" = "1.7.0";
    "org.opencontainers.image.description" = "Upstream reference — pull registry.k8s.io/autoscaling/vpa-recommender:1.7.0 directly.";
    "io.nix-containers.upstream-image" = "registry.k8s.io/autoscaling/vpa-recommender:1.7.0";
    "io.nix-containers.image.upstream" = "registry.k8s.io/autoscaling/vpa-recommender";
  };
}
