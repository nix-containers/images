# gitaly
# =====
# GitLab component — re-wrapped from the official CNG image at the current
# stable release (matches gitlab 19.1.1). nixpkgs lags; the CNG images are
# the official build behind the GitLab Helm chart.
# https://gitlab.com/gitlab-org/build/CNG
#
# Update: bump version + imageDigest
# (skopeo inspect docker://registry.gitlab.com/gitlab-org/build/cng/gitaly:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitaly 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.2";

  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitaly";
    imageDigest = "sha256:4bef56225255673f76a5e57a960147040642fb411fba93cba0f41ce9ad28cc29";
    sha256      = "sha256-LZulh4bNSDvfagJPAmtPs7H6P1VKiXdgowWC+H0HM+U=";
  };

in
nix2container.buildImage {
  name      = "gitaly";
  tag       = "v${version}";
  fromImage = upstreamImage;

  config = {
    Labels = {
      "org.opencontainers.image.title"   = "gitaly";
      "org.opencontainers.image.version" = version;
      "org.opencontainers.image.source"  = "https://gitlab.com/gitlab-org/build/CNG";
      "io.nix-containers.build-strategy" = "nix2container-pullImage";
      "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitaly:v19.1.1";
    };
  };
}
