# gitlab-sidekiq-ce
# =====
# GitLab component — re-wrapped from the official CNG image at 19.1.1 (matches
# the gitlab image). https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/gitlab-sidekiq-ce:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-sidekiq-ce 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.1";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-sidekiq-ce";
    imageDigest = "sha256:4c2a3b9b9feb35a513003a75f55fc478bd50e858d3d499130f4765570050903d";
    sha256      = "sha256-zQuJ1vcO8tceqXrRnb9xXE8liuVveFvAUkDFVw5ISYQ=";
  };
in
nix2container.buildImage {
  name = "gitlab-sidekiq-ce"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title"   = "gitlab-sidekiq-ce";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source"  = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-sidekiq-ce:v19.1.1";
  };
}
