# gitlab-base
# =====
# GitLab component — re-wrapped from the official CNG image at 19.1.1.
# https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/gitlab-base:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-base 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.1";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-base";
    imageDigest = "sha256:d4c18288bddaf6dd491be95b125919d7c4ce25bff945b3e526ef37270c3ce619";
    sha256      = "sha256-uzoU3DHGbk+5jQOXy1gX9e2dA0rB2y9zwkfleNv/0g0=";
  };
in
nix2container.buildImage {
  name = "gitlab-base"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title"   = "gitlab-base";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source"  = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-base:v19.1.1";
  };
}
