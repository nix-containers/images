{ nix2container, lib, pkgs, ... }:

# sonobuoy-systemd-logs — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/sonobuoy/systemd-logs:v0.4
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "sonobuoy-systemd-logs";
  tag = "v0.4";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.4";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/sonobuoy/systemd-logs:v0.4 directly.";
    "io.nix-containers.upstream-image" = "docker.io/sonobuoy/systemd-logs:v0.4";
    "io.nix-containers.image.upstream" = "docker.io/sonobuoy/systemd-logs";
  };
}
