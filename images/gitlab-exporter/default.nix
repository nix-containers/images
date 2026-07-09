# gitlab-exporter
# =====
# GitLab component — re-wrapped from the official CNG image at 19.1.1 (matches
# the gitlab image). https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/gitlab-exporter:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-exporter 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.2";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-exporter";
    imageDigest = "sha256:d85e2947630301a5bc04bfd28883bdcdb79400a3156f353c86ee3041bb0ee966";
    sha256      = "sha256-KQhQaaPmNAFripPbx6cFRCJtcM/fy5mX6L1RC9Uqnk8=";
  };
in
nix2container.buildImage {
  name = "gitlab-exporter"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title"   = "gitlab-exporter";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source"  = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-exporter:v19.1.1";
  };
}
