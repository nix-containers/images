{ mkImage, pkgs, lib, ... }:

# buildctl - BuildKit client CLI (from moby/buildkit)
# https://github.com/moby/buildkit
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "0.31.2";

  drv = pkgs.buildGoModule {
    pname = "buildctl";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "moby";
      repo = "buildkit";
      rev = "v${version}";
      hash = "sha256-lpcbCPsnvwMULeZgo1eQ0AqlfsyOMO/7b3ZOCoVTDKk=";
    };

    vendorHash = null;

    subPackages = [ "cmd/buildctl" ];
    ldflags = [ "-s" "-w" "-X github.com/moby/buildkit/version.Version=v${version}" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "buildctl-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/buildctl" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "buildctl";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
