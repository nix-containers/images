{ nix2container, lib, pkgs, ... }:

# falco-no-driver — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/falcosecurity/falco-no-driver:0.39.2
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "falco-no-driver";
  tag = "0.39.2";
  config.Labels = {
    "org.opencontainers.image.version" = "0.39.2";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/falcosecurity/falco-no-driver:0.39.2 directly.";
    "io.nix-containers.upstream-image" = "docker.io/falcosecurity/falco-no-driver:0.39.2";
    "io.nix-containers.image.upstream" = "docker.io/falcosecurity/falco-no-driver";
  };
}
