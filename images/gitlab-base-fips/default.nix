# gitlab-base-fips (FIPS) — re-wrapped from official CNG FIPS image at 19.1.1.
# Update: bump version + imageDigest (cng/gitlab-base:v<ver>-fips) + refresh sha256.
{ nix2container, pkgs, lib, ... }:
let
  version = "19.1.2";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-base";
    imageDigest = "sha256:90a8e7a2c544d37c079dd5e8ab99fb89cefbe55e13101c8f134fd40456b3350a";
    sha256      = "sha256-jPrm5cDI4FX0dM4cBDmkHNrponBTm6fWZI8tcNVvqLA=";
  };
in nix2container.buildImage {
  name = "gitlab-base-fips"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title" = "gitlab-base-fips";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source" = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-base:v19.1.1-fips";
  };
}