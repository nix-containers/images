{ nix2container, lib, pkgs, ... }:

# tetragon-bash-completion — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: quay.io/cilium/tetragon:v1.7.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "tetragon-bash-completion";
  tag = "v1.7.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.7.0";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/cilium/tetragon:v1.7.0 directly.";
    "io.nix-containers.upstream-image" = "quay.io/cilium/tetragon:v1.7.0";
    "io.nix-containers.image.upstream" = "quay.io/cilium/tetragon";
  };
}
