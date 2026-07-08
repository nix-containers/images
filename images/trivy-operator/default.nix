{ nix2container, lib, pkgs, ... }:

# trivy-operator — UPSTREAM REFERENCE (not built/hosted). Use ghcr.io/aquasecurity/trivy-operator:0.22.0 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "trivy-operator";
  tag = "0.22.0";
  config.Labels = {
    "org.opencontainers.image.version" = "0.22.0";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/aquasecurity/trivy-operator:0.22.0 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/aquasecurity/trivy-operator:0.22.0";
    "io.nix-containers.image.upstream" = "ghcr.io/aquasecurity/trivy-operator";
  };
}
