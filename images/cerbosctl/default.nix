{ mkImage, pkgs, lib, ... }:

# cerbosctl - command line client for Cerbos
# https://github.com/cerbos/cerbos
#
# Built from source with current nixpkgs Go so stdlib CVEs from the
# upstream prebuilt (stdlib v1.26.2 → 1.26.4) clear at each rebuild.

let
  version = "0.53.0";

  cerbosctl = pkgs.buildGoModule {
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

    meta = with lib; {
      description = "Command line client for Cerbos";
      homepage = "https://github.com/cerbos/cerbos";
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
    };
  };

in mkImage {
  drv = cerbosctl;
  name = "cerbosctl";
  tag = "v${version}";
  entrypoint = [ "${cerbosctl}/bin/cerbosctl" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "cerbosctl";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
