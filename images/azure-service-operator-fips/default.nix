{ mkImage, pkgs, lib, ... }:

# Azure Service Operator - asoctl CLI
# https://github.com/Azure/azure-service-operator
# -fips variant packages the upstream asoctl binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild. asoctl is a separate
# Go module under v2/cmd/asoctl.

let
  version = "2.20.0";

  drv = pkgs.buildGoModule {
    pname = "azure-service-operator-fips";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "Azure";
      repo = "azure-service-operator";
      rev = "v${version}";
      hash = "sha256-cJlINnBBueZUjQmBxGE/jwqmS1COBiIan721uatAFUs=";
    };

    modRoot = "v2/cmd/asoctl";
    proxyVendor = true;
    vendorHash = "sha256-aO3xbrDtQbIq9iCPvMF61ccteUGvJvyJcmaVzk1b9Pk=";

    subPackages = [ "." ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };

in mkImage {
  inherit drv;
  name = "azure-service-operator-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/asoctl" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "azure-service-operator-fips";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
