# gitlab-container-registry
# =====
# GitLab component — re-wrapped from the official CNG image at the current
# stable release (matches gitlab 19.1.1). nixpkgs lags; the CNG images are
# the official build behind the GitLab Helm chart.
# https://gitlab.com/gitlab-org/build/CNG
#
# Update: bump version + imageDigest
# (skopeo inspect docker://registry.gitlab.com/gitlab-org/build/cng/gitlab-container-registry:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-container-registry 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.2";

  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-container-registry";
    imageDigest = "sha256:1844e0562357b1e1a8d3f194f90965717f88bc06adb0fed0d54377d9709d4f54";
    sha256      = "sha256-86Ub74gEu+kLNjp2aBYtlZT7rnDwAN+7n7n5Vql+jy8=";
  };

in
nix2container.buildImage {
  name      = "gitlab-container-registry";
  tag       = "v${version}";
  fromImage = upstreamImage;

  config = {
    Labels = {
      "org.opencontainers.image.title"   = "gitlab-container-registry";
      "org.opencontainers.image.version" = version;
      "org.opencontainers.image.source"  = "https://gitlab.com/gitlab-org/build/CNG";
      "io.nix-containers.build-strategy" = "nix2container-pullImage";
      "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-container-registry:v19.1.1";
    };
  };
}
