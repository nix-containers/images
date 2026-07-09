# gitlab-sidekiq-ce
# =====
# GitLab component — re-wrapped from the official CNG image at 19.1.1 (matches
# the gitlab image). https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/gitlab-sidekiq-ce:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-sidekiq-ce 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.2";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-sidekiq-ce";
    imageDigest = "sha256:e23279dc81bb5716276749fd427452b774336f43746aa763908d3c48ad7605d6";
    sha256      = "sha256-XtsIGJ1FlwjZ7XPAmW61SlxyQxZwGTsF9M8rHa2Ltf4=";
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
