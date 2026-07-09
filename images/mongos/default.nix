{ mkImage, pkgs, lib, ... }:

# MongoDB sharded cluster router (mongos)
# https://www.mongodb.com
#
# Uses pkgs.mongodb-ce (nixpkgs Community Edition — currently 8.2.6, built
# from source). Prior revision consumed the upstream prebuilt tarball; the
# nixpkgs build re-links against current nixpkgs libs so system-CVE fixes
# propagate at each rebuild.
let
  drv = pkgs.mongodb-ce;
  version = drv.version;
in mkImage {
  inherit drv;
  name = "mongos";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/mongos" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "mongos";
    "org.opencontainers.image.description" = "MongoDB sharded cluster query router";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "nixpkgs";
  };
}
