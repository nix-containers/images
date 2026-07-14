{ mkImage, pkgs, lib, ... }:

# Ratify - verification framework for container images and artifacts
# https://github.com/notaryproject/ratify
#
# v1.4.0 prebuilt is Go-stdlib stale (2 crit CVEs). Rebuild from source
# at same tag with nixpkgs' Go.

let
  version = "1.4.3";

  drv = pkgs.buildGoModule {
    pname = "ratify";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "notaryproject";
      repo = "ratify";
      rev = "v${version}";
      hash = "sha256-EHvMkdw2QfxOgJD8AoRzP9LvmmJvjgCGJcQUlt3Hnkw=";
    };

    vendorHash = "sha256-qNoEjU/Ypy8zJUaiFh/9/tQqZi4E3Aqzb2nm2aKmDFw=";

    subPackages = [ "cmd/ratify" ];

    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };

in mkImage {
  inherit drv;
  name = "ratify";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/ratify" ];
  cmd = [];

  labels = {
    "org.opencontainers.image.title" = "ratify";
    "org.opencontainers.image.description" = "Verification framework for container images and artifacts";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "source-build";
  };
}
