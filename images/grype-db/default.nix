{ mkImage, pkgs, lib, ... }:

# grype-db - builds the vulnerability database used by grype
# https://github.com/anchore/grype-db
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "0.54.1";

  drv = pkgs.buildGoModule {
    pname = "grype-db";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "anchore";
      repo = "grype-db";
      rev = "v${version}";
      hash = "sha256-A0KSxnekw0wtSFpU6unRtZ0xzWlkQjQR8z5bU19EMBY=";
    };

    proxyVendor = true;
    vendorHash = "sha256-xgrwbK9xNnRT8htEyNTXkljcou1o/qV2lEgaXfiBhB4=";

    subPackages = [ "cmd/grype-db" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "grype-db";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/grype-db" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "grype-db";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
