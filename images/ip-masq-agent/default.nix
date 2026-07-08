{ nix2container, lib, pkgs, ... }:

# ip-masq-agent — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: registry.k8s.io/networking/ip-masq-agent:v2.9.3
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "ip-masq-agent";
  tag = "v2.9.3";
  config.Labels = {
    "org.opencontainers.image.version" = "v2.9.3";
    "org.opencontainers.image.description" = "Upstream reference — pull registry.k8s.io/networking/ip-masq-agent:v2.9.3 directly.";
    "io.nix-containers.upstream-image" = "registry.k8s.io/networking/ip-masq-agent:v2.9.3";
    "io.nix-containers.image.upstream" = "registry.k8s.io/networking/ip-masq-agent";
  };
}
