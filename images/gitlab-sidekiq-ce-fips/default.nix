# gitlab-sidekiq-ce-fips (FIPS) — re-wrapped from official CNG FIPS image at 19.1.1.
# Update: bump version + imageDigest (cng/gitlab-sidekiq-ce:v<ver>-fips) + refresh sha256.
{ nix2container, pkgs, lib, ... }:
let
  version = "19.1.1";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/gitlab-sidekiq-ce";
    imageDigest = "sha256:2cfca49b8d8dfec5de44f11731e22420063bbeb7221c6bd4916a2e6037e50659";
    sha256      = "sha256-LCuUdmXERvnpjPE9KoP6FL5WZloX+9UBrPpe8MY7CAE=";
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
