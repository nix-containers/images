# gitlab-webservice-ce
# =====
# GitLab component — re-wrapped from the official CNG image at 19.1.1 (matches
# the gitlab image). https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/gitlab-webservice-ce:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-webservice-ce 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.1";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-webservice-ce";
    imageDigest = "sha256:3604068977fbbeed497fc55fce81b1e62973bb4da60ea847410ee24db97e2fb5";
    sha256      = "sha256-VHtNaGtlDWsT9P6Mg9qBubfaSxIkDPMQxSQ19QPbUiw=";
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
