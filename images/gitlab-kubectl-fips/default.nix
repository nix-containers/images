# gitlab-kubectl-fips (FIPS) — re-wrapped from official CNG FIPS image at 19.1.1.
# Update: bump version + imageDigest (cng/kubectl:v<ver>-fips) + refresh sha256.
{ nix2container, pkgs, lib, ... }:
let
  version = "19.1.2";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/kubectl";
    imageDigest = "sha256:40df8937adf0a1f1affabde08012a28fe22013c6966bf69ae7def95215807a92";
    sha256      = "sha256-poSR9dhCa1OR1GObyDPwyLcpGrxYB2kRmyqbY+EeRvU=";
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