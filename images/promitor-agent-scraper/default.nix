{ nix2container, lib, pkgs, ... }:

# promitor-agent-scraper — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/tomkerkhove/promitor-agent-scraper:2.0.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "promitor-agent-scraper";
  tag = "2.0.0";
  config.Labels = {
    "org.opencontainers.image.version" = "2.0.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/tomkerkhove/promitor-agent-scraper:2.0.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/tomkerkhove/promitor-agent-scraper:2.0.0";
    "io.nix-containers.image.upstream" = "docker.io/tomkerkhove/promitor-agent-scraper";
  };
}
