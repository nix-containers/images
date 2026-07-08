{ nix2container, lib, pkgs, ... }:

# wso2is — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/wso2/wso2is:7.3.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "wso2is";
  tag = "7.3.0";
  config.Labels = {
    "org.opencontainers.image.version" = "7.3.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/wso2/wso2is:7.3.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/wso2/wso2is:7.3.0";
    "io.nix-containers.image.upstream" = "docker.io/wso2/wso2is";
  };
}
