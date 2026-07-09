{ mkImage, pkgs, lib, ... }:

# tdbg - Temporal debug CLI, shipped in the Temporal server release archive
# https://github.com/temporalio/temporal
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "1.31.2";

  drv = pkgs.buildGoModule {
    pname = "tdbg";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "temporalio";
      repo = "temporal";
      rev = "v${version}";
      hash = "sha256-NuvgeG1a7octJ2HD0EGQIdU8CtZsNRf4KX/F17S/uOQ=";
    };

    proxyVendor = true;
    vendorHash = "sha256-yDhdEFZrMpddw96Q1z2oQbQLtV56orliM9F13euI/m8=";

    subPackages = [ "cmd/tools/tdbg" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "tdbg";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/tdbg" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "tdbg";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
