# gitlab-webservice-ce
# =====
# GitLab component — re-wrapped from the official CNG image at 19.1.1 (matches
# the gitlab image). https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/gitlab-webservice-ce:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-webservice-ce 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.2";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-webservice-ce";
    imageDigest = "sha256:510d68e41c911a724ded885bb8dafaed328ee5303d68dac4c9bd0adb41f77967";
    sha256      = "sha256-LRGhTGstwQKyUPN9Sr5tueqONtBF1HoQEAHcWnke4iM=";
  };
in
nix2container.buildImage {
  name = "gitlab-webservice-ce"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title"   = "gitlab-webservice-ce";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source"  = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-webservice-ce:v19.1.1";
  };
}
