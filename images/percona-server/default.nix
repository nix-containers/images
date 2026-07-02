{ mkImage, pkgs, lib, ... }:

# Percona Server - Enhanced MySQL-compatible database
# https://www.percona.com/mysql/software/percona-server-for-mysql
#
# Was cmd=["--help"] (a one-shot -> the kind-test pod CrashLoops). mysqld needs
# an initialized data directory before it can start, so a docker-entrypoint.sh
# initializes an insecure datadir under the writable /tmp on first boot, then
# execs the server bound on 0.0.0.0:3306.

let
  percona = pkgs.percona-server;

  # docker-library-style entrypoint: initdb on first boot, then exec mysqld.
  # mysqld is on PATH via runtimeInputs; writeShellApplication runs shellcheck
  # at build.
  entrypoint = pkgs.writeShellApplication {
    name = "docker-entrypoint.sh";
    runtimeInputs = [ percona pkgs.coreutils ];
    text = builtins.readFile ./docker-entrypoint.sh;
  };
in
mkImage {
  drv = percona;
  name = "percona-server";
  tag = "v${percona.version}";
  entrypoint = [ "${entrypoint}/bin/docker-entrypoint.sh" ];
  cmd = [ ];

  labels = {
    "org.opencontainers.image.title" = "Percona Server";
    "org.opencontainers.image.description" = "Enhanced MySQL-compatible database server";
    "org.opencontainers.image.version" = percona.version;
  };
}
