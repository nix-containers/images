# gitlab-mailroom
# =====
# GitLab component — re-wrapped from the official CNG image at 19.1.1 (matches
# the gitlab image). https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/gitlab-mailroom:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-mailroom 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.2";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-mailroom";
    imageDigest = "sha256:627a9c03bf193dabf0df229413dadb2301b6e465c175e0b7481da21cb125ef61";
    sha256      = "sha256-YdjxGq9pNGKpdmJb45ec4bzl3BAJlAHt1PjQsbnlkaM=";
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
