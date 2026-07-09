# gitlab-toolbox-ce-fips (FIPS) — re-wrapped from official CNG FIPS image at 19.1.1.
# Update: bump version + imageDigest (cng/gitlab-toolbox-ce:v<ver>-fips) + refresh sha256.
{ nix2container, pkgs, lib, ... }:
let
  version = "19.1.2";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-toolbox-ce";
    imageDigest = "sha256:c5e3e70466669eadeaac674eefef313333b01d312ed0a290426f193e3f3aea6a";
    sha256      = "sha256-HyJrPhoXO4Lpds/9tcLnLlo7imD57iFbfFeb1M1I+6Y=";
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
