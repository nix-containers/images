# gitlab-toolbox-ce
# =====
# GitLab component — re-wrapped from the official CNG image at 19.1.1 (matches
# the gitlab image). https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/gitlab-toolbox-ce:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-toolbox-ce 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.2";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-toolbox-ce";
    imageDigest = "sha256:f7718cc9e6947171a6ac6adac1eaa83efb7f76bcc856ae930e68e15b6ca17e67";
    sha256      = "sha256-YA9BkVuETTLN0+SvVyTPc5/VZpvKxUNw+xCzVVO2mHA=";
  };
in
nix2container.buildImage {
  name = "gitlab-toolbox-ce"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title"   = "gitlab-toolbox-ce";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source"  = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-toolbox-ce:v19.1.1";
  };
}
