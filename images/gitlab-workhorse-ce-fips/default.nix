# gitlab-workhorse-ce-fips
# =====
# GitLab component (FIPS) — re-wrapped from the official CNG FIPS image at 19.1.1.
# https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/gitlab-workhorse-ce:v<ver>-fips --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-workhorse-ce-fips 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.2";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-workhorse-ce";
    imageDigest = "sha256:51508eb5c8ab98d892778588e8ac823861f89436887e6972df30a93fcacf6314";
    sha256      = "sha256-CO7BQLkt85zkNGlK9RwuhlVGvEtnQhO2PFGVveZvkFU=";
  };
in
nix2container.buildImage {
  name = "gitlab-workhorse-ce-fips"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title"   = "gitlab-workhorse-ce-fips";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source"  = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-workhorse-ce:v19.1.1-fips";
  };
}
