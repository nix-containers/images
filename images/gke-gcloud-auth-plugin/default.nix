{ nix2container, lib, pkgs, ... }:

# gke-gcloud-auth-plugin — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/google/cloud-sdk:575.0.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "gke-gcloud-auth-plugin";
  tag = "575.0.1";
  config.Labels = {
    "org.opencontainers.image.version" = "575.0.1";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/google/cloud-sdk:575.0.1 directly.";
    "io.nix-containers.upstream-image" = "docker.io/google/cloud-sdk:575.0.1";
    "io.nix-containers.image.upstream" = "docker.io/google/cloud-sdk";
  };
}
