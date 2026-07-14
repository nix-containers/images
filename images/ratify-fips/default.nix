{ mkImage, pkgs, lib, ... }:

# Ratify - verification framework for container images and artifacts
# (-fips variant; naming only, no FIPS claim)
# https://github.com/notaryproject/ratify
#
# Built from source with nixpkgs' current Go — see ratify/default.nix.

let
  version = "1.4.3";

  drv = pkgs.buildGoModule {
    pname = "ratify-fips";
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
  name = "ratify-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/ratify" ];
  cmd = [];
  labels = {
    "org.opencontainers.image.title" = "ratify-fips";
    "org.opencontainers.image.description" = "Verification framework for container images and artifacts";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "source-build";
  };
}
