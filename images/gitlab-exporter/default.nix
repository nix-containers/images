# gitlab-exporter
# =====
# GitLab component — re-wrapped from the official CNG image at 19.1.1 (matches
# the gitlab image). https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/gitlab-exporter:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-exporter 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.1";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-exporter";
    imageDigest = "sha256:523d15d24ff2596d2f60d763f9932cc9e33397e1e902df1d40940483b5cbeec9";
    sha256      = "sha256-01XI50jOR/x6sH4hHaIlahyQZw6HQgOCqkrlVdQWpjw=";
  };
in
nix2container.buildImage {
  name = "gitlab-exporter"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title"   = "gitlab-exporter";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source"  = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-exporter:v19.1.1";
  };
}
