# gitaly-fips
# =====
# GitLab component (FIPS) — re-wrapped from the official CNG FIPS image at 19.1.1.
# https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/gitaly:v<ver>-fips --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitaly-fips 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.2";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitaly";
    imageDigest = "sha256:c9a8616f474bbe1a3991e45e78f375f78c85dd38881f051daae0c441d421d32f";
    sha256      = "sha256-PuRTGneyadb+qlcOl/53T22neVnjLw5EnIdg9+7ZmhY=";
  };
in
nix2container.buildImage {
  name = "gitaly-fips"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title"   = "gitaly-fips";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source"  = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitaly:v19.1.1-fips";
  };
}
