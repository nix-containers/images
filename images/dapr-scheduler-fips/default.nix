{ mkImage, pkgs, lib, ... }:

# Dapr scheduler (dapr-scheduler-fips)
# https://github.com/dapr/dapr
# -fips variant packages the upstream binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "1.18.1";

  drv = pkgs.buildGoModule {
    pname = "scheduler";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "dapr";
      repo = "dapr";
      rev = "v${version}";
      hash = "sha256-vxsEJcjRe30vDgsYfdOVI8MvItZmI1vxzFFqb9f7RpA=";
    };

    proxyVendor = true;
    vendorHash = "sha256-TpDXL/APpsgb8zHPuzdD3bM8JI+lk/GzDovKk3rFaA0=";

    subPackages = [ "cmd/scheduler" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "dapr-scheduler-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/scheduler" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "dapr-scheduler-fips";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
