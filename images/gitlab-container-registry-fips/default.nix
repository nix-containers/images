# gitlab-container-registry-fips
# =====
# GitLab component (FIPS) — re-wrapped from the official CNG FIPS image at 19.1.1.
# https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/gitlab-container-registry:v<ver>-fips --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-container-registry-fips 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.2";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-container-registry";
    imageDigest = "sha256:a3ef97eb31250dcaee826681a3f53da7523d3d68933395351ce6eda401e642f8";
    sha256      = "sha256-tphzJLCZlO1tcGLrvM4OAbkNSnMMeXKCMOPP/L/1D6U=";
  };
in
nix2container.buildImage {
  name = "gitlab-container-registry-fips"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title"   = "gitlab-container-registry-fips";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source"  = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-container-registry:v19.1.1-fips";
  };
}
