{ mkImage, pkgs, lib, ... }:

# Grafana Mimir - horizontally scalable, multi-tenant Prometheus TSDB
# https://github.com/grafana/mimir
#
# Uses pkgs.mimir (built from source via nixpkgs + the flake.nix overlay
# that pins the current upstream release). This keeps Go-stdlib CVEs
# clearing on each rebuild instead of freezing to whatever the upstream
# prebuilt binary was compiled with.
let
  drv = pkgs.mimir;
  version = drv.version;

  # Minimal single-binary (monolithic) config: filesystem object storage under
  # the writable /tmp mkImage provides, single-node ingester ring, HTTP on
  # 0.0.0.0:8080 + gRPC on 0.0.0.0:9095. Mimir refuses to start without a config
  # (no queryable storage), so bake this default. Operators mount their own
  # config (real object store, multi-tenant, HA rings).
  mimirConfig = pkgs.writeTextDir "etc/mimir/config.yaml" ''
    multitenancy_enabled: false
    common:
      storage:
        backend: filesystem
        filesystem:
          dir: /tmp/mimir
    blocks_storage:
      backend: filesystem
      filesystem:
        dir: /tmp/mimir/blocks
      tsdb:
        dir: /tmp/mimir/tsdb
    compactor:
      data_dir: /tmp/mimir/compactor
    ruler_storage:
      backend: filesystem
      filesystem:
        dir: /tmp/mimir/ruler
    ingester:
      ring:
        replication_factor: 1
    server:
      http_listen_address: 0.0.0.0
      http_listen_port: 8080
      grpc_listen_address: 0.0.0.0
      grpc_listen_port: 9095
  '';
in mkImage {
  inherit drv;
  name = "grafana-mimir";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/mimir" ];
  # Was `--help` (a one-shot, so the kind-test pod CrashLoops). Run the
  # monolithic all-in-one target with the baked config above.
  cmd = [ "-target=all" "-config.file=/etc/mimir/config.yaml" ];
  extraPkgs = [ mimirConfig ];
  labels = {
    "org.opencontainers.image.title" = "grafana-mimir";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "nixpkgs";
  };
}
