{ mkImage, pkgs, lib, ... }:

# containerd-stress (fips variant) - stress testing tool shipped with containerd
# https://github.com/containerd/containerd
# -fips variant packages the upstream binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt static tarball clear at each rebuild.

let
  version = "2.3.2";

  drv = pkgs.buildGoModule {
    pname = "containerd-stress-fips";
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
  name = "containerd-stress-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/containerd-stress" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "containerd-stress-fips";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
