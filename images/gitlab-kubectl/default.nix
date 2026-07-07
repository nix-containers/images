# gitlab-kubectl
# =====
# GitLab component — re-wrapped from the official CNG image at 19.1.1.
# https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/kubectl:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-kubectl 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.1";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/kubectl";
    imageDigest = "sha256:6dc0172bbd9908a15d675903e0ac0dadbc40af473ac7d0d2b3f254bc84cf88f1";
    sha256      = "sha256-6FsAraF748d2BcN43seGf/Q9uuD/BsrSQiO35av19/E=";
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
