{ mkImage, pkgs, lib, ... }:

# Grafana Pyroscope - continuous profiling platform
# https://github.com/grafana/pyroscope
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "2.1.0";

  drv = pkgs.buildGoModule {
    pname = "grafana-pyroscope";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "grafana";
      repo = "pyroscope";
      rev = "v${version}";
      hash = "sha256-7bY3qmN05m/OxFyDxdwlxsvYrwzhdbkX0XhGqOzCZSA=";
    };

    proxyVendor = true;
    vendorHash = "sha256-UGWfrnpTgzR09T5jDL24d/Bs8+HBWi4g1YzZyy7ULWY=";

    subPackages = [ "cmd/pyroscope" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "grafana-pyroscope";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/pyroscope" ];
  cmd = [
    "-pyroscopedb.data-path=/tmp/data"
    "-metastore.data-dir=/tmp/data/metastore/data"
    "-metastore.raft.dir=/tmp/data/metastore/raft"
    "-metastore.raft.snapshots-dir=/tmp/data/metastore/snapshots"
    "-compactor.data-dir=/tmp/data/compactor"
    "-blocks-storage.bucket-store.sync-dir=/tmp/data/sync"
    "-embedded-grafana.data-path=/tmp/data/grafana"
    "-storage.filesystem.dir=/tmp/data/shared"
  ];
  labels = {
    "org.opencontainers.image.title" = "grafana-pyroscope";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
