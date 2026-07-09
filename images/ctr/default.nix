{ mkImage, pkgs, lib, ... }:

# ctr - containerd's low-level CLI client
# https://github.com/containerd/containerd
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt static tarball clear at each rebuild.

let
  version = "2.3.2";

  drv = pkgs.buildGoModule {
    pname = "ctr";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "containerd";
      repo = "containerd";
      rev = "v${version}";
      hash = "sha256-k/MU+boP0J6ttGDmEJuRh8fZjsJJCmeRRZe360yMUN4=";
    };

    vendorHash = null;

    subPackages = [ "cmd/ctr" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };

in mkImage {
  inherit drv;
  name = "ctr";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/ctr" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "ctr";
    "org.opencontainers.image.description" = "containerd CLI client";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
