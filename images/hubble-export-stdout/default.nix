{ mkImage, pkgs, lib, ... }:

# Hubble CLI - observability for Cilium (used for hubble export to stdout)
# https://github.com/cilium/hubble
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.
let
  version = "1.19.4";

  drv = pkgs.buildGoModule {
    pname = "hubble";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "cilium";
      repo = "hubble";
      rev = "v${version}";
      hash = "sha256-/O2w8AMEt5kKCpUKjknRIY2i/Do+i3gCCPOa384xgp8=";
    };

    vendorHash = null;

    subPackages = [ "." ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "hubble-export-stdout";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/hubble" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "hubble-export-stdout";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
