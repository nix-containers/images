{ mkImage, pkgs, lib, ... }:

# containerd-stress - stress testing tool shipped with containerd
# https://github.com/containerd/containerd
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt static tarball clear at each rebuild.

let
  version = "2.3.2";

  drv = pkgs.buildGoModule {
    pname = "containerd-stress";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "containerd";
      repo = "containerd";
      rev = "v${version}";
      hash = "sha256-k/MU+boP0J6ttGDmEJuRh8fZjsJJCmeRRZe360yMUN4=";
    };

    vendorHash = null;

    subPackages = [ "cmd/containerd-stress" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "containerd-stress";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/containerd-stress" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "containerd-stress";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
