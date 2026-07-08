{ nix2container, lib, pkgs, ... }:

# trillian-logserver — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: gcr.io/trillian-opensource-ci/log_server:v1.7.3
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "trillian-logserver";
  tag = "v1.7.3";
  config.Labels = {
    "org.opencontainers.image.version" = "v1.7.3";
    "org.opencontainers.image.description" = "Upstream reference — pull gcr.io/trillian-opensource-ci/log_server:v1.7.3 directly.";
    "io.nix-containers.upstream-image" = "gcr.io/trillian-opensource-ci/log_server:v1.7.3";
    "io.nix-containers.image.upstream" = "gcr.io/trillian-opensource-ci/log_server";
  };
}
