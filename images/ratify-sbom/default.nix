{ mkImage, pkgs, lib, ... }:

# Ratify SBOM verifier plugin
# https://github.com/notaryproject/ratify
#
# Built from source with nixpkgs' current Go — the plugin lives at
# plugins/verifier/sbom in the upstream repo.

let
  version = "1.4.3";

  drv = pkgs.buildGoModule {
    pname = "ratify-sbom";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "notaryproject";
      repo = "ratify";
      rev = "v${version}";
      hash = "sha256-EHvMkdw2QfxOgJD8AoRzP9LvmmJvjgCGJcQUlt3Hnkw=";
    };

    vendorHash = "sha256-qNoEjU/Ypy8zJUaiFh/9/tQqZi4E3Aqzb2nm2aKmDFw=";

    subPackages = [ "plugins/verifier/sbom" ];

    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "ratify-sbom";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/sbom" ];
  cmd = [];
  labels = {
    "org.opencontainers.image.title" = "ratify-sbom";
    "org.opencontainers.image.description" = "Ratify SBOM verifier plugin";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "source-build";
  };
}
