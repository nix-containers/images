# gitlab-mailroom
# =====
# GitLab component — re-wrapped from the official CNG image at 19.1.1 (matches
# the gitlab image). https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/gitlab-mailroom:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-mailroom 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.1";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-mailroom";
    imageDigest = "sha256:a7ef990ba0c5205dd3f9f9217912310d8a358e5f8511a4419c774be4521eb8d5";
    sha256      = "sha256-21AsbWpQod9Q4AtDkmERdubvmPlTHbCu7ETfjCbf7Co=";
  };
in
nix2container.buildImage {
  name = "gitlab-mailroom"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title"   = "gitlab-mailroom";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source"  = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-mailroom:v19.1.1";
  };
}
