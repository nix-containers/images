{ nix2container, lib, pkgs, ... }:

# nginx-s3-gateway-unprivileged — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/nginxinc/nginx-s3-gateway:unprivileged-oss
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "nginx-s3-gateway-unprivileged";
  tag = "unprivileged-oss";
  config.Labels = {
    "org.opencontainers.image.version" = "unprivileged-oss";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/nginxinc/nginx-s3-gateway:unprivileged-oss directly.";
    "io.nix-containers.upstream-image" = "docker.io/nginxinc/nginx-s3-gateway:unprivileged-oss";
    "io.nix-containers.image.upstream" = "docker.io/nginxinc/nginx-s3-gateway";
  };
}
