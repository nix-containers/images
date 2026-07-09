{ mkImage, pkgs, lib, ... }:

# Dapr placement (dapr-placement)
# https://github.com/dapr/dapr

#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "1.18.1";

  drv = pkgs.buildGoModule {
    pname = "placement";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "dapr";
      repo = "dapr";
      rev = "v${version}";
      hash = "sha256-vxsEJcjRe30vDgsYfdOVI8MvItZmI1vxzFFqb9f7RpA=";
    };

    proxyVendor = true;
    vendorHash = "sha256-TpDXL/APpsgb8zHPuzdD3bM8JI+lk/GzDovKk3rFaA0=";

    subPackages = [ "cmd/placement" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "dapr-placement";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/placement" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "dapr-placement";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
