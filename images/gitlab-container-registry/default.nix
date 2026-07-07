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
  version = "19.1.1";

  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-container-registry";
    imageDigest = "sha256:00f2a16359a0fd7e27d8a342af2cade31109d539952297aaa84d4dda93af825d";
    sha256      = "sha256-CIsn4DN1UMs2CTGq4XZAbA5df4Wvn3g+vZzpMfCX1Xw=";
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
