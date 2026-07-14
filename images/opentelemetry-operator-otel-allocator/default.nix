{ nix2container, lib, pkgs, ... }:

# opentelemetry-operator-otel-allocator — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/open-telemetry/opentelemetry-operator/target-allocator:0.97.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "opentelemetry-operator-otel-allocator";
  tag = "0.155.0";
  config.Labels = {
    "org.opencontainers.image.version" = "0.155.0";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/open-telemetry/opentelemetry-operator/target-allocator:0.97.0 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/open-telemetry/opentelemetry-operator/target-allocator:0.97.0";
    "io.nix-containers.image.upstream" = "ghcr.io/open-telemetry/opentelemetry-operator/target-allocator";
  };
}
