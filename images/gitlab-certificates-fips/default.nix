# gitlab-certificates-fips (FIPS) — re-wrapped from official CNG FIPS image at 19.1.1.
# Update: bump version + imageDigest (cng/certificates:v<ver>-fips) + refresh sha256.
{ nix2container, pkgs, lib, ... }:
let
  version = "19.1.1";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/certificates";
    imageDigest = "sha256:f725b5b572b553e54873848261b6cdea3a1e59aec6c42d4cf7954337633fb778";
    sha256      = "sha256-Q7iq0aTNiWuWiC2ymZy193f5epDFRZhtTVi4TVV2xoc=";
  };
in nix2container.buildImage {
  name = "gitlab-certificates-fips"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title" = "gitlab-certificates-fips";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source" = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/certificates:v19.1.1-fips";
  };
}
