# gitlab-base
# =====
# GitLab component — re-wrapped from the official CNG image at 19.1.1.
# https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/gitlab-base:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-base 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.2";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-base";
    imageDigest = "sha256:6aceb9427ae3daa0b8769b51cd6d9591563e62d4aa062f0bdd044822dbe50d92";
    sha256      = "sha256-JUEq2IsVgeAHf2/ycxjodQji9Gixa2jBJMA6BNW5WHQ=";
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
