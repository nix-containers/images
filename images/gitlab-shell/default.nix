# gitlab-shell
# =====
# GitLab component — re-wrapped from the official CNG image at the current
# stable release (matches gitlab 19.1.1). nixpkgs lags; the CNG images are
# the official build behind the GitLab Helm chart.
# https://gitlab.com/gitlab-org/build/CNG
#
# Update: bump version + imageDigest
# (skopeo inspect docker://registry.gitlab.com/gitlab-org/build/cng/gitlab-shell:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-shell 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.1";

  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-shell";
    imageDigest = "sha256:e47772b2efaa61d60f59341bcbd5cb4ded6583a7a89e14bc59685078c2ce2680";
    sha256      = "sha256-seHCcmKnY5mXj0zDTW3PFDrJQ+RMsvkDmjWCG2+FgLo=";
  };

in
nix2container.buildImage {
  name      = "gitlab-shell";
  tag       = "v${version}";
  fromImage = upstreamImage;

  config = {
    Labels = {
      "org.opencontainers.image.title"   = "gitlab-shell";
      "org.opencontainers.image.version" = version;
      "org.opencontainers.image.source"  = "https://gitlab.com/gitlab-org/build/CNG";
      "io.nix-containers.build-strategy" = "nix2container-pullImage";
      "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-shell:v19.1.1";
    };
  };
}
