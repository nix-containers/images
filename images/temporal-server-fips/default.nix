{ mkImage, pkgs, lib, ... }:

# Temporal Server (-fips variant) - built from source
# https://github.com/temporalio/temporal
# -fips variant packages the upstream binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt release clear at each rebuild.
let
  version = "1.31.2";
  drv = pkgs.buildGoModule {
    pname = "temporal-server-fips";
    inherit version;
    src = pkgs.fetchFromGitHub {
      owner = "temporalio";
      repo = "temporal";
      rev = "v${version}";
      hash = "sha256-NuvgeG1a7octJ2HD0EGQIdU8CtZsNRf4KX/F17S/uOQ=";
    };
    proxyVendor = true;
    vendorHash = "sha256-yDhdEFZrMpddw96Q1z2oQbQLtV56orliM9F13euI/m8=";

    subPackages = [ "cmd/server" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    postInstall = ''
      if [ -e $out/bin/server ]; then
        mv $out/bin/server $out/bin/temporal-server
      fi
      cp -r config $out/config
    '';
  };
in mkImage {
  inherit drv;
  name = "temporal-server-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/temporal-server" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "temporal-server-fips";
    "org.opencontainers.image.description" = "Temporal durable execution platform server";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
