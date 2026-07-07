# gitlab-webservice-ce-fips (FIPS) — re-wrapped from official CNG FIPS image at 19.1.1.
# Update: bump version + imageDigest (cng/gitlab-webservice-ce:v<ver>-fips) + refresh sha256.
{ nix2container, pkgs, lib, ... }:
let
  version = "19.1.1";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-webservice-ce";
    imageDigest = "sha256:8bd5df23f846d2416e3ca1156241e8b0d3cd076b70a201016d1a5e5fcc602814";
    sha256      = "sha256-47GThkFs2YhjzPMLzBNGz1J47tLWIqJxj6h48hpPXXE=";
  };
in nix2container.buildImage {
  name = "gitlab-webservice-ce-fips"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title" = "gitlab-webservice-ce-fips";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source" = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/gitlab-webservice-ce:v19.1.1-fips";
  };
}
