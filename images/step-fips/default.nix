{ mkImage, pkgs, lib, ... }:

# Smallstep step CLI - https://github.com/smallstep/cli
# -fips variant packages the upstream step binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.
let
  version = "0.30.6";
  drv = pkgs.buildGoModule {
    pname = "step";
    inherit version;
    src = pkgs.fetchFromGitHub {
      owner = "smallstep";
      repo = "cli";
      rev = "v${version}";
      hash = "sha256-OJNG4GWolYLO2KlsnwNANcNWaPTxJ3wpSWNrdzjyYAs=";
    };
    proxyVendor = true;
    vendorHash = "sha256-nK6MT042fM4r6bu3NJPagsanJyR3/kP631LgO5ctQK4=";

    subPackages = [ "cmd/step" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "step-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/step" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "step-fips";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
