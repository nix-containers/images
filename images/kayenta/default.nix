{ nix2container, lib, pkgs, ... }:

# kayenta — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: us-docker.pkg.dev/spinnaker-community/docker/kayenta:0.13.1-20200501030017
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "kayenta";
  tag = "0.13.1-20200501030017";
  config.Labels = {
    "org.opencontainers.image.version" = "0.13.1-20200501030017";
    "org.opencontainers.image.description" = "Upstream reference — pull us-docker.pkg.dev/spinnaker-community/docker/kayenta:0.13.1-20200501030017 directly.";
    "io.nix-containers.upstream-image" = "us-docker.pkg.dev/spinnaker-community/docker/kayenta:0.13.1-20200501030017";
    "io.nix-containers.image.upstream" = "us-docker.pkg.dev/spinnaker-community/docker/kayenta";
  };
}
