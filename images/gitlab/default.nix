# gitlab
# ======
# GitLab CE — DevOps platform. https://gitlab.com/gitlab-org/gitlab
#
# Build strategy: nix2container.pullImage (re-wrap upstream official image)
# ------------------------------------------------------------------------
# nixpkgs lags GitLab (18.11.6) and 19.x's frontend is mid Vue2->Vue3 +
# webpack->Vite migration that nixpkgs hasn't packaged. To ship the latest
# STABLE release we re-wrap GitLab's official image (same artifact behind the
# omnibus packages), pinned by digest.
#
# Update to a newer stable: bump `version` + `imageDigest`
# (skopeo inspect docker://gitlab/gitlab-ce:<ver>-ce.0 --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab 2>&1 | grep "got:"

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.2";

  upstreamImage = nix2container.pullImage {
    imageName   = "gitlab/gitlab-ce";
    imageDigest = "sha256:ed48f1d320841a393c3b8c3a9558f28117a4ebdbb35538b43a73467aabd9590a";
    sha256      = "sha256-JMI/hWXP1UEEBoAnZesNcFgBc7vUNS8/FMI+XIvMTQE=";
  };

in
nix2container.buildImage {
  name      = "gitlab";
  tag       = "v${version}";
  fromImage = upstreamImage;

  config = {
    Labels = {
      "org.opencontainers.image.title"       = "GitLab";
      "org.opencontainers.image.description" = "GitLab Community Edition (latest stable, from upstream official image)";
      "org.opencontainers.image.version"     = version;
      "org.opencontainers.image.source"      = "https://gitlab.com/gitlab-org/gitlab";
      "io.nix-containers.build-strategy"     = "nix2container-pullImage";
      "io.nix-containers.upstream-image"     = "docker.io/gitlab/gitlab-ce:19.1.1-ce.0";
    };
  };
}
