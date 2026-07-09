# gitlab-workhorse-ce
# =====
# GitLab component — re-wrapped from the official CNG image at the current
# stable release (matches gitlab 19.1.1). nixpkgs lags; the CNG images are
# the official build behind the GitLab Helm chart.
# https://gitlab.com/gitlab-org/build/CNG
#
# Update: bump version + imageDigest
# (skopeo inspect docker://registry.gitlab.com/gitlab-org/build/cng/gitlab-workhorse-ce:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-workhorse-ce 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.2";

  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-workhorse-ce";
    imageDigest = "sha256:25cfd44cbb16e00b9517cb1c1a35633990f78acbaa98ef5cd8e4e533bfc3b192";
    sha256      = "sha256-RptD+h7doI6Ip5dK0vAEg59e5geeketMclotASjT/cs=";
  };

in
nix2container.buildImage {
  name      = "gitlab-workhorse-ce";
  tag       = "v${version}";
  fromImage = upstreamImage;

  config = {
    Labels = {
      "org.opencontainers.image.title"   = "gitlab-workhorse-ce";
      "org.opencontainers.image.version" = version;
      "org.opencontainers.image.source"  = "https://gitlab.com/gitlab-org/build/CNG";
      "io.nix-containers.build-strategy" = "nix2container-pullImage";
      "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-workhorse-ce:v19.1.1";
    };
  };
}
