# gitlab-kubectl-fips (FIPS) — re-wrapped from official CNG FIPS image at 19.1.1.
# Update: bump version + imageDigest (cng/kubectl:v<ver>-fips) + refresh sha256.
{ nix2container, pkgs, lib, ... }:
let
  version = "19.1.1";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/kubectl";
    imageDigest = "sha256:d8c2fed75f224f71b6952af86b9fd0e50d7a212b75a036d5f8979d62a9cd6dd4";
    sha256      = "sha256-YQU/3pwOVScADELswIrLa1mSenAhCRRH9Geq17lGleE=";
  };
in nix2container.buildImage {
  name = "gitlab-kubectl-fips"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title" = "gitlab-kubectl-fips";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source" = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/kubectl:v19.1.1-fips";
  };
}
