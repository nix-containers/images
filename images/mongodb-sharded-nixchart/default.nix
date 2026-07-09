{ mkImage, pkgs, lib, ... }:

# MongoDB for sharded clusters. Ships both mongod and mongos so the
# image can act as a shard/config server (mongod) or query router (mongos).
# https://www.mongodb.com
#
# Uses pkgs.mongodb-ce (nixpkgs Community Edition — currently 8.2.6),
# swapping the upstream prebuilt tarball for the source-built package.
let
  drv = pkgs.mongodb-ce;
  version = drv.version;
in mkImage {
  inherit drv;
  name = "mongodb-sharded-nixchart";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/mongos" ];
  cmd = [];
  user = "1001:0";

  labels = {
    "org.opencontainers.image.title" = "mongodb-sharded-nixchart";
    "org.opencontainers.image.description" = "MongoDB server and router for sharded clusters";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "nixpkgs";
  };
}
