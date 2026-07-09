# gitlab-shell-fips
# =====
# GitLab component (FIPS) — re-wrapped from the official CNG FIPS image at 19.1.1.
# https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/gitlab-shell:v<ver>-fips --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-shell-fips 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.2";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-shell";
    imageDigest = "sha256:5bb615d1076857e06f3cef6903ff6f69d1c01841a5189b9b4b139bbd9431f818";
    sha256      = "sha256-ILjb34YrdR+54/SOv53RgYrPuMcrl8OMLAYnjl8c6RI=";
  };
in
nix2container.buildImage {
  name = "gitlab-shell-fips"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title"   = "gitlab-shell-fips";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source"  = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-shell:v19.1.1-fips";
  };
}
