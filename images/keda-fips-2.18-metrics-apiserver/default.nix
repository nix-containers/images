{ nix2container, lib, pkgs, ... }:

# keda-fips-2.18-metrics-apiserver — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/kedacore/keda-metrics-apiserver:2.6.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "keda-fips-2.18-metrics-apiserver";
  tag = "2.6.1";
  config.Labels = {
    "org.opencontainers.image.version" = "2.6.1";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/kedacore/keda-metrics-apiserver:2.6.1 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/kedacore/keda-metrics-apiserver:2.6.1";
    "io.nix-containers.image.upstream" = "ghcr.io/kedacore/keda-metrics-apiserver";
  };
}
