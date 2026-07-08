{ mkImage, pkgs, lib, ... }:

# KOTS - Replicated kots CLI / kubectl plugin
# https://github.com/replicatedhq/kots
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "1.130.7";

  drv = pkgs.buildGoModule {
    pname = "kots";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "replicatedhq";
      repo = "kots";
      rev = "v${version}";
      hash = "sha256-3QcR1DEhJQpJisHYOn+zrq/fFgqTAViCVUDGy23GeZk=";
    };

    proxyVendor = true;
    vendorHash = "sha256-h350Dui1aGgYiv1IhnYbvlKhQ5GmG3Y5Y0uuBrfgdyc=";

    subPackages = [ "cmd/kots" ];
    ldflags = [ "-s" "-w" "-X github.com/replicatedhq/kots/pkg/buildversion.version=${version}" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "kots";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/kots" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "kots";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
