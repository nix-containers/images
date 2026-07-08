{ nix2container, lib, pkgs, ... }:

# azure-workload-identity-webhook — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: mcr.microsoft.com/oss/azure/workload-identity/webhook:v1.5.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "azure-workload-identity-webhook";
  tag = "v1.5.1";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.5.1";
    "org.opencontainers.image.description" = "Upstream reference — pull mcr.microsoft.com/oss/azure/workload-identity/webhook:v1.5.1 directly.";
    "io.nix-containers.upstream-image" = "mcr.microsoft.com/oss/azure/workload-identity/webhook:v1.5.1";
    "io.nix-containers.image.upstream" = "mcr.microsoft.com/oss/azure/workload-identity/webhook";
  };
}
