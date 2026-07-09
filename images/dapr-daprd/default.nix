{ mkImage, pkgs, lib, ... }:

# Dapr daprd (dapr-daprd)
# https://github.com/dapr/dapr

#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "1.18.1";

  drv = pkgs.buildGoModule {
    pname = "daprd";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "dapr";
      repo = "dapr";
      rev = "v${version}";
      hash = "sha256-vxsEJcjRe30vDgsYfdOVI8MvItZmI1vxzFFqb9f7RpA=";
    };

    proxyVendor = true;
    vendorHash = "sha256-TpDXL/APpsgb8zHPuzdD3bM8JI+lk/GzDovKk3rFaA0=";

    subPackages = [ "cmd/daprd" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "dapr-daprd";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/daprd" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "dapr-daprd";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
