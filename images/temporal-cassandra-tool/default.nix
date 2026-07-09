{ mkImage, pkgs, lib, ... }:

# Temporal Cassandra schema/admin tool
# https://github.com/temporalio/temporal
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt release clear at each rebuild.
let
  version = "1.31.2";
  drv = pkgs.buildGoModule {
    pname = "temporal-cassandra-tool";
    inherit version;
    src = pkgs.fetchFromGitHub {
      owner = "temporalio";
      repo = "temporal";
      rev = "v${version}";
      hash = "sha256-NuvgeG1a7octJ2HD0EGQIdU8CtZsNRf4KX/F17S/uOQ=";
    };
    proxyVendor = true;
    vendorHash = "sha256-yDhdEFZrMpddw96Q1z2oQbQLtV56orliM9F13euI/m8=";

    subPackages = [ "cmd/tools/cassandra" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    postInstall = ''
      if [ -e $out/bin/cassandra ]; then
        mv $out/bin/cassandra $out/bin/temporal-cassandra-tool
      fi
    '';
  };
in mkImage {
  inherit drv;
  name = "temporal-cassandra-tool";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/temporal-cassandra-tool" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "temporal-cassandra-tool";
    "org.opencontainers.image.description" = "Temporal Cassandra schema management tool";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
