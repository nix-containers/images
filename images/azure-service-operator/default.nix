{ mkImage, pkgs, lib, ... }:

# asoctl - CLI for Azure Service Operator
# https://github.com/Azure/azure-service-operator
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild. The Go module lives
# under the v2/ subdirectory.

let
  version = "2.20.0";

  drv = pkgs.buildGoModule {
    pname = "asoctl";
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

    postInstall = ''
      if [ -e $out/bin/asoctl ]; then
        :  # already correct name
      elif [ -e $out/bin/cmd ]; then
        mv $out/bin/cmd $out/bin/asoctl
      fi
    '';
  };
in mkImage {
  inherit drv;
  name = "azure-service-operator";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/asoctl" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "azure-service-operator";
    "org.opencontainers.image.description" = "asoctl CLI for Azure Service Operator";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
