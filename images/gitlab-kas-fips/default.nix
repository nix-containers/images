# gitlab-kas-fips (FIPS) — re-wrapped from official CNG FIPS image at 19.1.1.
# Update: bump version + imageDigest (cng/gitlab-kas:v<ver>-fips) + refresh sha256.
{ nix2container, pkgs, lib, ... }:
let
  version = "19.1.1";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-kas";
    imageDigest = "sha256:8e84d4a4a59d0d158dd9cb30956c03aad0921369ba97954e9fd591fe0e7bce70";
    sha256      = "sha256-dn3tyu5FyhVQfCBPCGqdeCcV9Ci4KisYr2VU+tcRzM8=";
  };
in nix2container.buildImage {
  name = "gitlab-kas-fips"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title" = "gitlab-kas-fips";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source" = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-kas:v19.1.1-fips";
  };
}
