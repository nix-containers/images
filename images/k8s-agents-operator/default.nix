{ nix2container, lib, pkgs, ... }:

# k8s-agents-operator — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/newrelic/k8s-agents-operator:0.44.3
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "k8s-agents-operator";
  tag = "0.44.3";
  config.Labels = {
    "org.opencontainers.image.version" = "0.44.3";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/newrelic/k8s-agents-operator:0.44.3 directly.";
    "io.nix-containers.upstream-image" = "docker.io/newrelic/k8s-agents-operator:0.44.3";
    "io.nix-containers.image.upstream" = "docker.io/newrelic/k8s-agents-operator";
  };
}
