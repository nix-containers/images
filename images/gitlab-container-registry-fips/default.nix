# gitlab-container-registry-fips
# =====
# GitLab component (FIPS) — re-wrapped from the official CNG FIPS image at 19.1.1.
# https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/gitlab-container-registry:v<ver>-fips --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-container-registry-fips 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.1";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-container-registry";
    imageDigest = "sha256:81d52ac15cf05858eadbc8dd7cf79f4dbcbb676a0cebba6441c79e00cb06b856";
    sha256      = "sha256-sI9FwK2mh6RdsVthVfI5rhUqrRLoQohcCdGV6JdrqmM=";
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
