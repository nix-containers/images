{ nix2container, lib, pkgs, ... }:

# logstash-oss-with-opensearch-output-plugin — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/opensearchproject/logstash-oss-with-opensearch-output-plugin:8.9.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "logstash-oss-with-opensearch-output-plugin";
  tag = "8.9.0";
  config.Labels = {
    "org.opencontainers.image.version" = "8.9.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/opensearchproject/logstash-oss-with-opensearch-output-plugin:8.9.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/opensearchproject/logstash-oss-with-opensearch-output-plugin:8.9.0";
    "io.nix-containers.image.upstream" = "docker.io/opensearchproject/logstash-oss-with-opensearch-output-plugin";
  };
}
