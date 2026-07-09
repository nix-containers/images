# gitlab-webservice-ce-fips (FIPS) — re-wrapped from official CNG FIPS image at 19.1.1.
# Update: bump version + imageDigest (cng/gitlab-webservice-ce:v<ver>-fips) + refresh sha256.
{ nix2container, pkgs, lib, ... }:
let
  version = "19.1.2";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-webservice-ce";
    imageDigest = "sha256:869e7f68e3189358944e064ab67569ba60cf90c00e68c71aeba9b5eb2f747789";
    sha256      = "sha256-kbPNQzkAb0laNJs1gSLduzpFKduUQOmx+JhF9r6wCPQ=";
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
