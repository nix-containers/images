# gitlab-kas-fips (FIPS) — re-wrapped from official CNG FIPS image at 19.1.1.
# Update: bump version + imageDigest (cng/gitlab-kas:v<ver>-fips) + refresh sha256.
{ nix2container, pkgs, lib, ... }:
let
  version = "19.1.2";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-kas";
    imageDigest = "sha256:be6a410ccdf8dece10a321a71d22ee4c7b5e2ac69768732aec07be24bf142deb";
    sha256      = "sha256-L8kI7diebGegRuNtEYbS84qAAtdrSk7yDhaDj4drmro=";
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