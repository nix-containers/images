{ mkImage, pkgs, lib, ... }:

# tetra - CLI for Tetragon (Cilium eBPF-based security observability & runtime enforcement)
# https://github.com/cilium/tetragon
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "1.7.0";

  drv = pkgs.buildGoModule {
    pname = "tetra";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "cilium";
      repo = "tetragon";
      rev = "v${version}";
      hash = "sha256-MOBT2hdzssrWW34v0K4CE4qlAmB+Y7F/R5kAxjl6yT8=";
    };

    vendorHash = null;

    subPackages = [ "cmd/tetra" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    meta = with lib; {
      description = "CLI for Tetragon";
      homepage = "https://github.com/cilium/tetragon";
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
    };
  };

in mkImage {
  inherit drv;
  name = "tetra";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/tetra" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "tetra";
    "org.opencontainers.image.description" = "CLI for Tetragon";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
