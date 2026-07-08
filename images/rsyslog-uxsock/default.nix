{ nix2container, lib, pkgs, ... }:

# rsyslog-uxsock — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/rsyslog/syslog_appliance_alpine:8.36.0-3.7
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "rsyslog-uxsock";
  tag = "8.36.0-3.7";
  config.Labels = {
    "org.opencontainers.image.version" = "8.36.0-3.7";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/rsyslog/syslog_appliance_alpine:8.36.0-3.7 directly.";
    "io.nix-containers.upstream-image" = "docker.io/rsyslog/syslog_appliance_alpine:8.36.0-3.7";
    "io.nix-containers.image.upstream" = "docker.io/rsyslog/syslog_appliance_alpine";
  };
}
