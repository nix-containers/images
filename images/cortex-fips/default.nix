{ mkImage, pkgs, lib, ... }:

# Cortex - horizontally scalable, multi-tenant Prometheus-as-a-service
# https://github.com/cortexproject/cortex
# -fips variant packages the upstream cortex binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "1.21.1";

  drv = pkgs.buildGoModule {
    pname = "cortex";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "cortexproject";
      repo = "cortex";
      rev = "v${version}";
      hash = "sha256-qi+9MLjCrlN7u4WKweKiCn58H0/gr+8TblZkNRk+7Uw=";
    };

    vendorHash = null;

    subPackages = [ "cmd/cortex" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "cortex-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/cortex" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "cortex-fips";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
