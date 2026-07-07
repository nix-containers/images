{ mkImage, pkgs, lib, ... }:

# cerbosctl (-fips variant) - command-line interface for Cerbos
# https://github.com/cerbos/cerbos
# Same upstream tool as cerbosctl; no FIPS claim made.
#
# Built from source with current nixpkgs Go so stdlib CVEs from the
# upstream prebuilt (stdlib v1.26.2 → 1.26.4) clear at each rebuild.
let
  version = "0.53.0";

  drv = pkgs.buildGoModule {
    pname = "cerbosctl";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "cerbos";
      repo = "cerbos";
      rev = "v${version}";
      hash = "sha256-Pge4nxR7UMY1a8ytzIWUJZHYBKO5iXvjZJiG8PTG4co=";
    };

    proxyVendor = true;
    vendorHash = "sha256-lGC/c+av1KMSzhV8PDVrckKIjShOACe9f4+DdF6Wkxg=";

    subPackages = [ "cmd/cerbosctl" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "cerbosctl-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/cerbosctl" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "cerbosctl-fips";
    "org.opencontainers.image.description" = "Cerbos command-line interface";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
