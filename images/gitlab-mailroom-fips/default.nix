# gitlab-mailroom-fips (FIPS) — re-wrapped from official CNG FIPS image at 19.1.1.
# Update: bump version + imageDigest (cng/gitlab-mailroom:v<ver>-fips) + refresh sha256.
{ nix2container, pkgs, lib, ... }:
let
  version = "19.1.2";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-mailroom";
    imageDigest = "sha256:f04e370534b2920c06ae9e3b4815ef0f7353f1cde5b663f2fdd6617ce077f2b5";
    sha256      = "sha256-vgwDLkn8O47zu3aDdejQc6gBuoHaF4P29YEXxWT1NdU=";
  };
in nix2container.buildImage {
  name = "gitlab-mailroom-fips"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title" = "gitlab-mailroom-fips";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source" = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-mailroom:v19.1.1-fips";
  };
}