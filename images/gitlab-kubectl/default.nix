# gitlab-kubectl
# =====
# GitLab component — re-wrapped from the official CNG image at 19.1.1.
# https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/kubectl:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-kubectl 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.2";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/kubectl";
    imageDigest = "sha256:91e436b869a236a8b341a63c9dc8f856f9a0297b303c7af6d160d19618d50684";
    sha256      = "sha256-vThaF4bAaTw2VNxe3emdI35JGCfBEHIbY0iMoLwn688=";
  };
in
nix2container.buildImage {
  name = "gitlab-kubectl"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title"   = "gitlab-kubectl";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source"  = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/kubectl:v19.1.1";
  };
}
