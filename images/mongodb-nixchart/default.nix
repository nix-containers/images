{ mkImage, pkgs, lib, ... }:

# mongodb-nixchart
# ================
# MongoDB Community Server for the nix-containers `mongodb` chart.
#
# Uses pkgs.mongodb-ce (nixpkgs — 8.2.6, built from source). Prior revision
# consumed the upstream prebuilt tarball to "avoid the multi-hour source
# build of pkgs.mongodb"; nixpkgs' mongodb-ce derivation is cached via
# cache.nixos.org so this pulls the pre-built store path in seconds and
# re-links against current libs on each rebuild.

let
  drv = pkgs.mongodb-ce;
  version = drv.version;

  entrypoint = pkgs.writeShellScript "mongodb-entrypoint" ''
    set -euo pipefail
    DATA_DIR="''${MONGODB_DATA_DIR:-/data/db}"
    PORT="''${MONGODB_PORT_NUMBER:-27017}"
    BIND_IP="''${MONGODB_BIND_IP:-0.0.0.0}"
    mkdir -p "$DATA_DIR"

    if [ -z "$(ls -A "$DATA_DIR" 2>/dev/null)" ]; then
      if [ -z "''${MONGODB_ROOT_PASSWORD:-}" ] && [ "''${MONGODB_ALLOW_EMPTY_PASSWORD:-no}" != "yes" ]; then
        echo "mongodb-nixchart: MONGODB_ROOT_PASSWORD is required (or set MONGODB_ALLOW_EMPTY_PASSWORD=yes)" >&2
        exit 1
      fi
      : # First-run bootstrap; auth setup requires the mongosh client which
        # nixpkgs' prebuilt does not always ship. Users can seed via
        # /docker-entrypoint-initdb.d/ scripts run externally.
    fi

    exec ${drv}/bin/mongod \
      --dbpath "$DATA_DIR" \
      --port "$PORT" \
      --bind_ip "$BIND_IP" \
      ''${MONGODB_ROOT_PASSWORD:+--auth} \
      ''${MONGODB_EXTRA_FLAGS:-} \
      "$@"
  '';

in mkImage {
  inherit drv;
  name = "mongodb-nixchart";
  tag = "v${version}";
  entrypoint = [ "${entrypoint}" ];
  cmd = [];
  user = "1001:0";
  labels = {
    "org.opencontainers.image.title" = "mongodb-nixchart";
    "org.opencontainers.image.description" = "MongoDB tuned for the nix-containers charts/mongodb chart";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "mongodb";
    "io.nix-containers.source" = "nixpkgs";
  };
}
