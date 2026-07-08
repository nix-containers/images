{ nix2container, lib, pkgs, ... }:

# gitlab-rails-ce-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: registry.gitlab.com/gitlab-org/build/cng/gitlab-rails-ce:v18.11.4-fips
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "gitlab-rails-ce-fips";
  tag = "v18.11.4-fips";
  config.Labels = {
    "org.opencontainers.image.version" = "v18.11.4-fips";
    "org.opencontainers.image.description" = "Upstream reference — pull registry.gitlab.com/gitlab-org/build/cng/gitlab-rails-ce:v18.11.4-fips directly.";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-rails-ce:v18.11.4-fips";
    "io.nix-containers.image.upstream" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-rails-ce";
  };
}
