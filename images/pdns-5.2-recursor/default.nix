{ nix2container, lib, pkgs, ... }:

# pdns-5.2-recursor — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/powerdns/pdns-recursor-52:5.2.11
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "pdns-5.2-recursor";
  tag = "5.2.11";
  config.Labels = {
    "org.opencontainers.image.version" = "5.2.11";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/powerdns/pdns-recursor-52:5.2.11 directly.";
    "io.nix-containers.upstream-image" = "docker.io/powerdns/pdns-recursor-52:5.2.11";
    "io.nix-containers.image.upstream" = "docker.io/powerdns/pdns-recursor-52";
  };
}
