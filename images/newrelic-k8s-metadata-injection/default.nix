{ nix2container, lib, pkgs, ... }:

# newrelic-k8s-metadata-injection — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/newrelic/k8s-metadata-injection:1.43.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "newrelic-k8s-metadata-injection";
  tag = "1.43.0";
  config.Labels = {
    "org.opencontainers.image.version" = "1.43.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/newrelic/k8s-metadata-injection:1.43.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/newrelic/k8s-metadata-injection:1.43.0";
    "io.nix-containers.image.upstream" = "docker.io/newrelic/k8s-metadata-injection";
  };
}
