# gitlab-kas
# ==========
# GitLab Kubernetes Agent Server — re-wrapped from the official CNG image at
# 19.1.1. https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/gitlab-kas:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-kas 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.1";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-kas";
    imageDigest = "sha256:3e875b511033ee303c579c8b70319f66a136198149cc7c45878ad044194fc516";
    sha256      = "sha256-H9i0kb1k1hkCB0Cyg4DoKGI4fbSBLamhLMbcHT5c/mg=";
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
