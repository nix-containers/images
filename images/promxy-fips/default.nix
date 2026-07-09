{ mkImage, pkgs, lib, ... }:

# promxy (-fips variant) - same upstream promxy tool (Prometheus proxy)
# https://github.com/jacksontj/promxy
# -fips variant packages the upstream binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "0.0.96";

  drv = pkgs.buildGoModule {
    pname = "promxy-fips";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "jacksontj";
      repo = "promxy";
      rev = "v${version}";
      hash = "sha256-qj9Sd4TdTD94VWnNB8/kIvHm+mYhfoRCqdsNeRNpoV0=";
    };

    vendorHash = null;

    subPackages = [ "cmd/promxy" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "promxy-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/promxy" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "promxy-fips";
    "org.opencontainers.image.description" = "Prometheus proxy aggregating multiple Prometheus servers";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
