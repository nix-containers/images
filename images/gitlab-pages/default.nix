# gitlab-pages
# =====
# GitLab component — re-wrapped from the official CNG image at the current
# stable release (matches gitlab 19.1.1). nixpkgs lags; the CNG images are
# the official build behind the GitLab Helm chart.
# https://gitlab.com/gitlab-org/build/CNG
#
# Update: bump version + imageDigest
# (skopeo inspect docker://registry.gitlab.com/gitlab-org/build/cng/gitlab-pages:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-pages 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.1";

  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-pages";
    imageDigest = "sha256:f3ea3a227a0fbfca3ed6a81d5a46c97db6b853eaded153ce5d54a8c330971057";
    sha256      = "sha256-69j15T84WeQiCXYZkK0SUXpjaQJeDsY4U+s2UUmw+Rw=";
  };

in
nix2container.buildImage {
  name      = "gitlab-pages";
  tag       = "v${version}";
  fromImage = upstreamImage;

  config = {
    Labels = {
      "org.opencontainers.image.title"   = "gitlab-pages";
      "org.opencontainers.image.version" = version;
      "org.opencontainers.image.source"  = "https://gitlab.com/gitlab-org/build/CNG";
      "io.nix-containers.build-strategy" = "nix2container-pullImage";
      "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-pages:v19.1.1";
    };
  };
}
