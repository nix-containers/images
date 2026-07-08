# gitlab-toolbox-ce-fips (FIPS) — re-wrapped from official CNG FIPS image at 19.1.1.
# Update: bump version + imageDigest (cng/gitlab-toolbox-ce:v<ver>-fips) + refresh sha256.
{ nix2container, pkgs, lib, ... }:
let
  version = "19.1.1";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-toolbox-ce";
    imageDigest = "sha256:97c4fa35b8c9e4fa585506ca3b77e6d1762f922b9135b739e0bd58f4ad256cb3";
    sha256      = "sha256-OD+15sF88p7f2j2W3ZXZz29z+glyt9mfIsxW5GKz2nk=";
  };
in nix2container.buildImage {
  name = "gitlab-toolbox-ce-fips"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title" = "gitlab-toolbox-ce-fips";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source" = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-toolbox-ce:v19.1.1-fips";
  };
}
