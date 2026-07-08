{ mkImage, pkgs, lib, ... }:

# crictl - CLI for CRI-compatible container runtimes
# https://github.com/kubernetes-sigs/cri-tools
#
# Prior revision consumed the upstream prebuilt release tarball whose Go
# stdlib carries the accumulated CVEs from the version it was built with.
# Build from source so the stdlib forward-fixes at each rebuild.

let
  version = "1.36.0";

  crictl = pkgs.buildGoModule {
    pname = "crictl";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "kubernetes-sigs";
      repo = "cri-tools";
      rev = "v${version}";
      hash = "sha256-Ae0CL/BZdIBzZr+Tttg6sNhn1eS2E1odR6fGpbFRVjI=";
    };

    vendorHash = null;

    subPackages = [ "cmd/crictl" ];
    ldflags = [ "-s" "-w" "-X sigs.k8s.io/cri-tools/pkg/version.Version=v${version}" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    meta = with lib; {
      description = "CLI for CRI-compatible container runtimes";
      homepage = "https://github.com/kubernetes-sigs/cri-tools";
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
    };
  };

in mkImage {
  drv = crictl;
  name = "crictl";
  tag = "v${version}";
  entrypoint = [ "${crictl}/bin/crictl" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "crictl";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
