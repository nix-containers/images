# gitlab-certificates-fips (FIPS) — re-wrapped from official CNG FIPS image at 19.1.1.
# Update: bump version + imageDigest (cng/certificates:v<ver>-fips) + refresh sha256.
{ nix2container, pkgs, lib, ... }:
let
  version = "19.1.2";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/certificates";
    imageDigest = "sha256:63e165aca06d5f7fec203156124d423861119b42e4c70363c02d7df511adc71d";
    sha256      = "sha256-e8MQa91DIpvEXUr6HgmGFlYgbeeKtoqvRpm3miDNBXs=";
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
