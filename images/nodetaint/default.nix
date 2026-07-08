{ nix2container, lib, pkgs, ... }:

# nodetaint — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: quay.io/wish/nodetaint:v0.0.4
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "nodetaint";
  tag = "v0.0.4";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.0.4";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/wish/nodetaint:v0.0.4 directly.";
    "io.nix-containers.upstream-image" = "quay.io/wish/nodetaint:v0.0.4";
    "io.nix-containers.image.upstream" = "quay.io/wish/nodetaint";
  };
}
