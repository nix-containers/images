# gitlab-certificates
# =====
# GitLab component — re-wrapped from the official CNG image at 19.1.1.
# https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/certificates:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-certificates 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.1";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/certificates";
    imageDigest = "sha256:00c7d5c5008d83cb935537cb18b54cbcd8294eb5baa8e40ac8b6a8948e297b82";
    sha256      = "sha256-vyM8nKCSUdnbpbVaDMleP5mhYHXQbFRe1RF8FInBKBo=";
  };
in
nix2container.buildImage {
  name = "gitlab-certificates"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title"   = "gitlab-certificates";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source"  = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/certificates:v19.1.1";
  };
}
