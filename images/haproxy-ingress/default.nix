{ nix2container, lib, pkgs, ... }:

# haproxy-ingress — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/jcmoraisjr/haproxy-ingress:v0.15.4
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "haproxy-ingress";
  tag = "v0.15.4";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.15.4";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/jcmoraisjr/haproxy-ingress:v0.15.4 directly.";
    "io.nix-containers.upstream-image" = "docker.io/jcmoraisjr/haproxy-ingress:v0.15.4";
    "io.nix-containers.image.upstream" = "docker.io/jcmoraisjr/haproxy-ingress";
  };
}
