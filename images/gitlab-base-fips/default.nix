# gitlab-base-fips (FIPS) — re-wrapped from official CNG FIPS image at 19.1.1.
# Update: bump version + imageDigest (cng/gitlab-base:v<ver>-fips) + refresh sha256.
{ nix2container, pkgs, lib, ... }:
let
  version = "19.1.1";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-base";
    imageDigest = "sha256:5f18efc9e6c9af7d54d3fa792ffb9f1693c16054ec419e7e0a7d04da95f146d4";
    sha256      = "sha256-oauGeuRJS4+onvNiFipdk8NUJKbBTnPlKRt9azKTStA=";
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
