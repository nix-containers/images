{ mkImage, pkgs, lib, ... }:

# Dapr injector (dapr-injector)
# https://github.com/dapr/dapr

#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "1.18.1";

  drv = pkgs.buildGoModule {
    pname = "injector";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "dapr";
      repo = "dapr";
      rev = "v${version}";
      hash = "sha256-vxsEJcjRe30vDgsYfdOVI8MvItZmI1vxzFFqb9f7RpA=";
    };

    proxyVendor = true;
    vendorHash = "sha256-TpDXL/APpsgb8zHPuzdD3bM8JI+lk/GzDovKk3rFaA0=";

    subPackages = [ "cmd/injector" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "dapr-injector";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/injector" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "dapr-injector";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
