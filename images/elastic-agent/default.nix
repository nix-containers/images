{ nix2container, lib, pkgs, ... }:

# elastic-agent — UPSTREAM REFERENCE (not built/hosted). Use docker.elastic.co/elastic-agent/elastic-agent:9.0.4 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "elastic-agent";
  tag = "9.0.4";
  config.Labels = {
    "org.opencontainers.image.version" = "9.0.4";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.elastic.co/elastic-agent/elastic-agent:9.0.4 directly.";
    "io.nix-containers.upstream-image" = "docker.elastic.co/elastic-agent/elastic-agent:9.0.4";
    "io.nix-containers.image.upstream" = "docker.elastic.co/elastic-agent/elastic-agent";
  };
}
