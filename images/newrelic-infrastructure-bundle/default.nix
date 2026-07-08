{ nix2container, lib, pkgs, ... }:

# newrelic-infrastructure-bundle — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/newrelic/infrastructure-bundle:3.3.33
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "newrelic-infrastructure-bundle";
  tag = "3.3.33";
  config.Labels = {
    "org.opencontainers.image.version" = "3.3.33";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/newrelic/infrastructure-bundle:3.3.33 directly.";
    "io.nix-containers.upstream-image" = "docker.io/newrelic/infrastructure-bundle:3.3.33";
    "io.nix-containers.image.upstream" = "docker.io/newrelic/infrastructure-bundle";
  };
}
