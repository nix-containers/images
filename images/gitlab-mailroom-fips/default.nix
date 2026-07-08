# gitlab-mailroom-fips (FIPS) — re-wrapped from official CNG FIPS image at 19.1.1.
# Update: bump version + imageDigest (cng/gitlab-mailroom:v<ver>-fips) + refresh sha256.
{ nix2container, pkgs, lib, ... }:
let
  version = "19.1.1";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-mailroom";
    imageDigest = "sha256:eb59b0ef379268703ddb340e3c358d4ec56b08e1b20481f30244311625f578e1";
    sha256      = "sha256-ml5dkl2RsFKO/6rcdv8Hbywg4Zk1OR/B5y8BGQl2ulE=";
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
