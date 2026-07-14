{ mkImage, pkgs, lib, ... }:

# Kiali - observability console for the Istio service mesh
# https://github.com/kiali/kiali
# -fips variant packages the upstream Kiali binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "2.29.0";

  drv = pkgs.buildGoModule {
    pname = "kiali";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "kiali";
      repo = "kiali";
      rev = "v${version}";
      hash = "sha256-vtKk+cEtEBHgqIJ2gLcy5AlaNQnzQKugEyYH28YlaKY=";
    };

    proxyVendor = true;
    vendorHash = "sha256-wdDvvzB5njkqddlKLIbUUEqjBEejtqv/UqWxq5LzHAk=";

    # Kiali's main lives at the repo root as kiali.go (package main).
    subPackages = [ "." ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    # frontend/frontend.go embeds `all:build` (the JS UI bundle) which is
    # normally produced by yarn build. The backend doesn't need the assets
    # to compile, but the embed directive requires the dir exist.
    preBuild = ''
      mkdir -p frontend/build
      touch frontend/build/index.html
    '';
  };
in mkImage {
  inherit drv;
  name = "kiali-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/kiali" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "kiali-fips";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
