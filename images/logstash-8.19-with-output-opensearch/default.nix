{ nix2container, lib, pkgs, ... }:

# logstash-8.19-with-output-opensearch — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.elastic.co/logstash/logstash:8.19.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "logstash-8.19-with-output-opensearch";
  tag = "8.19.0";
  config.Labels = {
    "org.opencontainers.image.version" = "8.19.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.elastic.co/logstash/logstash:8.19.0 directly.";
    "io.nix-containers.upstream-image" = "docker.elastic.co/logstash/logstash:8.19.0";
    "io.nix-containers.image.upstream" = "docker.elastic.co/logstash/logstash";
  };
}
