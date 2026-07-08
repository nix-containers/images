{ nix2container, lib, pkgs, ... }:

# nginx-mainline-mod-http_image_filter — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/library/nginx:1.31.2
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "nginx-mainline-mod-http_image_filter";
  tag = "1.31.2";
  config.Labels = {
    "org.opencontainers.image.version" = "1.31.2";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/library/nginx:1.31.2 directly.";
    "io.nix-containers.upstream-image" = "docker.io/library/nginx:1.31.2";
    "io.nix-containers.image.upstream" = "docker.io/library/nginx";
  };
}
