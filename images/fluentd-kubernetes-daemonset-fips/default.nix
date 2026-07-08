{ nix2container, lib, pkgs, ... }:

# fluentd-kubernetes-daemonset-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/fluent/fluentd-kubernetes-daemonset:v1.19.3-debian-forward-1.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "fluentd-kubernetes-daemonset-fips";
  tag = "v1.19.3-debian-forward-1.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.19.3-debian-forward-1.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/fluent/fluentd-kubernetes-daemonset:v1.19.3-debian-forward-1.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/fluent/fluentd-kubernetes-daemonset:v1.19.3-debian-forward-1.0";
    "io.nix-containers.image.upstream" = "docker.io/fluent/fluentd-kubernetes-daemonset";
  };
}
