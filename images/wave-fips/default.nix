{ nix2container, lib, pkgs, ... }:

# wave-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: quay.io/wave-k8s/wave:v0.11.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "wave-fips";
  tag = "v0.11.0";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.11.0";
    "org.opencontainers.image.description" = "Upstream reference — pull quay.io/wave-k8s/wave:v0.11.0 directly.";
    "io.nix-containers.upstream-image" = "quay.io/wave-k8s/wave:v0.11.0";
    "io.nix-containers.image.upstream" = "quay.io/wave-k8s/wave";
  };
}
