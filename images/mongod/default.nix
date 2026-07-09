{ mkImage, pkgs, lib, ... }:

# MongoDB server daemon (mongod)
# https://www.mongodb.com
#
# Uses pkgs.mongodb-ce (nixpkgs Community Edition — currently 8.2.6, built
# from source with the C++ toolchain). Prior revision consumed the upstream
# fastdl.mongodb.org prebuilt tarball, which pins the bundled openssl / zlib /
# curl to whatever MongoDB compiled with; the nixpkgs build re-links against
# current nixpkgs libs so system-CVE fixes propagate at each rebuild.
let
  drv = pkgs.mongodb-ce;
  version = drv.version;

  # The old cmd was `--help` (a one-shot -> the kind-test pod CrashLoops). mongod
  # also refuses to start without an existing --dbpath, so create it at runtime
  # under the writable /tmp mkImage provides, then exec the server bound on all
  # interfaces (0.0.0.0:27017). Operators mount their own volume at /tmp/mongodb
  # (or override the command) for real data.
  entrypoint = pkgs.writeShellApplication {
    name = "docker-entrypoint.sh";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      mkdir -p /tmp/mongodb
      exec ${drv}/bin/mongod --dbpath /tmp/mongodb --bind_ip_all "$@"
    '';
  };

in mkImage {
  inherit drv;
  name = "mongod";
  tag = "v${version}";
  entrypoint = [ "${entrypoint}/bin/docker-entrypoint.sh" ];
  cmd = [ ];

  labels = {
    "org.opencontainers.image.title" = "mongod";
    "org.opencontainers.image.description" = "MongoDB database server daemon";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "nixpkgs";
  };
}
