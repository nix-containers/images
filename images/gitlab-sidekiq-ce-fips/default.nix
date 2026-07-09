# gitlab-sidekiq-ce-fips (FIPS) — re-wrapped from official CNG FIPS image at 19.1.1.
# Update: bump version + imageDigest (cng/gitlab-sidekiq-ce:v<ver>-fips) + refresh sha256.
{ nix2container, pkgs, lib, ... }:
let
  version = "19.1.2";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-sidekiq-ce";
    imageDigest = "sha256:478397502aac1945963a13d243e313db30a09c6ba960af5561d2355f63146e95";
    sha256      = "sha256-yksiOjWREnAW+iXJRy2lCOLKShM0VsX0voD9y4/F4ew=";
  };
in nix2container.buildImage {
  name = "gitlab-sidekiq-ce-fips"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title" = "gitlab-sidekiq-ce-fips";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source" = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-sidekiq-ce:v19.1.1-fips";
  };
}
