{ nix2container, lib, pkgs, ... }:

# dnsdist-2.0-nodnscrypt — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/powerdns/dnsdist-20:2.0.7
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "dnsdist-2.0-nodnscrypt";
  tag = "2.0.7";
  config.Labels = {
    "org.opencontainers.image.version" = "2.0.7";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/powerdns/dnsdist-20:2.0.7 directly.";
    "io.nix-containers.upstream-image" = "docker.io/powerdns/dnsdist-20:2.0.7";
    "io.nix-containers.image.upstream" = "docker.io/powerdns/dnsdist-20";
  };
}
