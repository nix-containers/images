# gitlab-certificates
# =====
# GitLab component — re-wrapped from the official CNG image at 19.1.1.
# https://gitlab.com/gitlab-org/build/CNG
# Update: bump version + imageDigest (skopeo inspect
# docker://registry.gitlab.com/gitlab-org/build/cng/certificates:v<ver> --format '{{.Digest}}')
# then refresh sha256: nix build --no-link .#gitlab-certificates 2>&1 | grep 'got:'

{ nix2container, pkgs, lib, ... }:

let
  version = "19.1.2";
  upstreamImage = nix2container.pullImage {
    imageName   = "registry.gitlab.com/gitlab-org/build/cng/certificates";
    imageDigest = "sha256:d69d68aaf97816abd8198fe90e1d4c50b3a036b8887d16912703511aa07327fc";
    sha256      = "sha256-RxRQy95C0xxDklTfKQCL8n2fOTRbQt/Vj47M+oqFZoc=";
  };
in
nix2container.buildImage {
  name = "gitlab-certificates"; tag = "v${version}"; fromImage = upstreamImage;
  config.Labels = {
    "org.opencontainers.image.title"   = "gitlab-certificates";
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.source"  = "https://gitlab.com/gitlab-org/build/CNG";
    "io.nix-containers.build-strategy" = "nix2container-pullImage";
    "io.nix-containers.upstream-image" = "registry.gitlab.com/gitlab-org/build/cng/certificates:v19.1.1";
  };
}
