{ mkImage, pkgs, lib, ... }:

# Stakater Reloader - https://github.com/stakater/Reloader
# -fips variant packages the upstream binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.
let
  version = "1.4.17";
  drv = pkgs.buildGoModule {
    pname = "reloader";
    inherit version;
    src = pkgs.fetchFromGitHub {
      owner = "stakater";
      repo = "Reloader";
      rev = "v${version}";
      hash = "sha256-V95gDRlP3noXbc1PO+U+g0LBoD6qlWG+EG3k2BNZTZI=";
    };

    proxyVendor = true;
    vendorHash = "sha256-H8ruUzLgCkhl4Yz9xEEDpuLED/Fr9Sg/RFwp8TBxKgg=";

    subPackages = [ "." ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    postInstall = ''
      if [ -e $out/bin/Reloader ]; then
        mv $out/bin/Reloader $out/bin/reloader
      fi
    '';
  };
in mkImage {
  inherit drv;
  name = "stakater-reloader-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/reloader" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "stakater-reloader-fips";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
