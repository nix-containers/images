{ nix2container, lib, pkgs, ... }:

# gitlab-logger-fips — UPSTREAM REFERENCE (not built/hosted). Use registry.gitlab.com/gitlab-org/build/cng/gitlab-logger:v19.1.2-build-fips directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "gitlab-logger-fips";
  tag = "v19.1.2-build-fips";
  config.Labels = {
    "org.opencontainers.image.version" = "v19.1.2-build-fips";
    "org.opencontainers.image.description" = "Upstream reference — pull registry.gitlab.com/gitlab-org/build/cng/gitlab-logger:v19.1.2-build-fips directly.";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-logger:v19.1.2-build-fips";
    "io.nix-containers.image.upstream" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-logger";
  };
}
