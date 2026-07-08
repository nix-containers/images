{ nix2container, lib, pkgs, ... }:

# gitlab-rails-ce — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: registry.gitlab.com/gitlab-org/build/cng/gitlab-rails-ce:v18.11.4
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "gitlab-rails-ce";
  tag = "v18.11.4";
  config.Labels = {
    "org.opencontainers.image.version" = "v18.11.4";
    "org.opencontainers.image.description" = "Upstream reference — pull registry.gitlab.com/gitlab-org/build/cng/gitlab-rails-ce:v18.11.4 directly.";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-rails-ce:v18.11.4";
    "io.nix-containers.image.upstream" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-rails-ce";
  };
}
