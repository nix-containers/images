{ nix2container, lib, pkgs, ... }:

# opentelemetry-java-instrumentation — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: ghcr.io/open-telemetry/opentelemetry-operator/autoinstrumentation-java:2.29.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "opentelemetry-java-instrumentation";
  tag = "2.29.0";
  config.Labels = {
    "org.opencontainers.image.version" = "2.29.0";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/open-telemetry/opentelemetry-operator/autoinstrumentation-java:2.29.0 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/open-telemetry/opentelemetry-operator/autoinstrumentation-java:2.29.0";
    "io.nix-containers.image.upstream" = "ghcr.io/open-telemetry/opentelemetry-operator/autoinstrumentation-java";
  };
}
