# gitlab-logger
# =====
# GitLab component — re-wrapped from the official CNG image at 19.1.1.
# https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/gitlab-logger:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-logger 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.1";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-logger";
    imageDigest = "sha256:2a656a35a7188308a43c9a4cdb1bd4b54924173bc8c57514b2ad7baa28cdb59a";
    sha256      = "sha256-Cca2mEVD6Y2eV0cZfgL4c6vKOqMSQNPvt0Drc8O8xVw=";
  };
in
nix2container.buildImage {
  name = "gitlab-logger"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title"   = "gitlab-logger";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source"  = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-logger:v19.1.1";
  };
}
