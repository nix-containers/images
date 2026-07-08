{ nix2container, lib, pkgs, ... }:

# step-issuer-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/smallstep/step-issuer:0.12.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "step-issuer-fips";
  tag = "0.12.0";
  config.Labels = {
    "org.opencontainers.image.version" = "0.12.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/smallstep/step-issuer:0.12.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/smallstep/step-issuer:0.12.0";
    "io.nix-containers.image.upstream" = "docker.io/smallstep/step-issuer";
  };
}
