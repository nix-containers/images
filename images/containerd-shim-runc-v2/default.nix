{ mkImage, pkgs, lib, ... }:

# containerd-shim-runc-v2 (from containerd/containerd)
# https://github.com/containerd/containerd
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt static tarball clear at each rebuild.
let
  version = "2.3.2";
  binary = "containerd-shim-runc-v2";

  drv = pkgs.buildGoModule {
    pname = binary;
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "containerd";
      repo = "containerd";
      rev = "v${version}";
      hash = "sha256-k/MU+boP0J6ttGDmEJuRh8fZjsJJCmeRRZe360yMUN4=";
    };

    vendorHash = null;

    subPackages = [ "cmd/${binary}" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "containerd-shim-runc-v2";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/${binary}" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "containerd-shim-runc-v2";
    "org.opencontainers.image.description" = "containerd runc v2 runtime shim";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
