# gitlab-kas
# ==========
# GitLab Kubernetes Agent Server — re-wrapped from the official CNG image at
# 19.1.1. https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/gitlab-kas:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-kas 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.2";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-kas";
    imageDigest = "sha256:bdef1b6abd916eea352fe036488bc0e923dd1bc5a4af5665fbda7628424235dc";
    sha256      = "sha256-BjH1SiLtpYioNH/dUlvTjADtrEwRSH71zHoj8ElzrcU=";
  };
in
nix2container.buildImage {
  name = "gitlab-kas"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title"   = "gitlab-kas";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source"  = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-kas:v19.1.1";
  };
}
