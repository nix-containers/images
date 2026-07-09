{ mkImage, pkgs, lib, ... }:

# InfluxDB 2.x server daemon (influxd) - https://github.com/influxdata/influxdb
#
# Uses pkgs.influxdb2-server (nixpkgs, currently 2.7.12 — buildGoModule from
# source, with the Rust flux engine wired in). Same version as we were pinning
# via the upstream prebuilt tarball, but every rebuild picks up current Go
# stdlib CVE fixes.
let
  drv = pkgs.influxdb2-server;
  version = drv.version;
in mkImage {
  inherit drv;
  name = "influxd";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/influxd" ];
  # influxd binds HTTP on 0.0.0.0:8086 by default. bolt/engine/sqlite
  # stores default to $HOME/.influxdbv2 — resolved from the passwd entry
  # (which is read-only here) — so point them at the writable /tmp mkImage
  # provides. Operators mount a PVC and override.
  cmd = [
    "--bolt-path=/tmp/influxdb/influxd.bolt"
    "--engine-path=/tmp/influxdb/engine"
    "--sqlite-path=/tmp/influxdb/influxd.sqlite"
  ];

  labels = {
    "org.opencontainers.image.title" = "influxd";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "nixpkgs";
  };
}
