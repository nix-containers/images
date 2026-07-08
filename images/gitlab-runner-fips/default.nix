{ nix2container, lib, pkgs, ... }:

# gitlab-runner-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/gitlab/gitlab-runner:ubi-fips-v18.11.4
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "gitlab-runner-fips";
  tag = "ubi-fips-v18.11.4";
  config.Labels = {
    "org.opencontainers.image.version" = "ubi-fips-v18.11.4";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/gitlab/gitlab-runner:ubi-fips-v18.11.4 directly.";
    "io.nix-containers.upstream-image" = "docker.io/gitlab/gitlab-runner:ubi-fips-v18.11.4";
    "io.nix-containers.image.upstream" = "docker.io/gitlab/gitlab-runner";
  };
}
