{ nix2container, lib, pkgs, ... }:

# tofu-controller-runner — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/flux-iac/tf-runner:v0.16.4
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "tofu-controller-runner";
  tag = "v0.16.4";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.16.4";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/flux-iac/tf-runner:v0.16.4 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/flux-iac/tf-runner:v0.16.4";
    "io.nix-containers.image.upstream" = "ghcr.io/flux-iac/tf-runner";
  };
}
