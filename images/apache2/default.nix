{ nix2container, lib, pkgs, ... }:

# apache2 — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/library/httpd:2.4.68
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "apache2";
  tag = "2.4.68";
  config.Labels = {
    "org.opencontainers.image.version" = "2.4.68";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/library/httpd:2.4.68 directly.";
    "io.nix-containers.upstream-image" = "docker.io/library/httpd:2.4.68";
    "io.nix-containers.image.upstream" = "docker.io/library/httpd";
  };
}
