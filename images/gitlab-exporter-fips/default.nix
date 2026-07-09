# gitlab-exporter-fips (FIPS) — re-wrapped from official CNG FIPS image at 19.1.1.
# Update: bump version + imageDigest (cng/gitlab-exporter:v<ver>-fips) + refresh sha256.
{ nix2container, pkgs, lib, ... }:
let
  version = "19.1.2";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-exporter";
    imageDigest = "sha256:39ad6c0faf708c31380d67d0d5563d2a473e4d89bfd4d293fbc1cb96b15efb18";
    sha256      = "sha256-WOV7R2+DoLRNIG51VEQrtKQpy/gsoCoc0vtbGwf2RBk=";
  };
in nix2container.buildImage {
  name = "gitlab-exporter-fips"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title" = "gitlab-exporter-fips";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source" = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-exporter:v19.1.1-fips";
  };
}