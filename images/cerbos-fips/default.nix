{ mkImage, pkgs, lib, ... }:

# Cerbos (-fips variant) - stateless authorization layer / PDP
# https://github.com/cerbos/cerbos
# Same upstream tool as cerbos; no FIPS claim made.
#
# Built from source with current nixpkgs Go so stdlib CVEs from the
# upstream prebuilt (stdlib v1.26.2 → 1.26.4) clear at each rebuild.

let
  version = "0.53.0";

  drv = pkgs.buildGoModule {
    pname = "cerbos";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "cerbos";
      repo = "cerbos";
      rev = "v${version}";
      hash = "sha256-Pge4nxR7UMY1a8ytzIWUJZHYBKO5iXvjZJiG8PTG4co=";
    };

    proxyVendor = true;
    vendorHash = "sha256-lGC/c+av1KMSzhV8PDVrckKIjShOACe9f4+DdF6Wkxg=";

    subPackages = [ "cmd/cerbos" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "cerbos-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/cerbos" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "cerbos-fips";
    "org.opencontainers.image.description" = "Cerbos authorization layer";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
