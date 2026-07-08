{ mkImage, pkgs, lib, ... }:

# boring-registry - open source Terraform/OpenTofu module and provider registry
# https://github.com/boring-registry/boring-registry
# -fips variant packages the upstream boring-registry binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.
let
  version = "0.18.0";

  drv = pkgs.buildGoModule {
    pname = "boring-registry";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "boring-registry";
      repo = "boring-registry";
      rev = "v${version}";
      hash = "sha256-ytbc0lZEqS+xKXmrEASAna622zfl0UlBd/QK+vayI14=";
    };

    vendorHash = null;

    subPackages = [ "." ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "boring-registry-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/boring-registry" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "boring-registry";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
