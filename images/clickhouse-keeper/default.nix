{ mkImage, pkgs, lib, ... }:

# ClickHouse Keeper - ZooKeeper-compatible coordination service for ClickHouse
# https://github.com/ClickHouse/ClickHouse
let
  version = "26.5.4.21";

  drv = pkgs.stdenv.mkDerivation {
    pname = "clickhouse-keeper";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://packages.clickhouse.com/tgz/stable/clickhouse-keeper-${version}-amd64.tgz";
      hash = "sha256-MhUaBqv4TE+HgCEyhVC2dMt3fEK5jZFByq2tCu0aiz0=";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.stdenv.cc.cc.lib ];

    sourceRoot = "clickhouse-keeper-${version}";

    dontStrip = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 usr/bin/clickhouse-keeper $out/bin/clickhouse-keeper
      ln -s clickhouse-keeper $out/bin/clickhouse-keeper-client
      ln -s clickhouse-keeper $out/bin/clickhouse-keeper-converter
      runHook postInstall
    '';
  };

  # The old cmd was `--help` (a one-shot -> the kind-test pod CrashLoops), and
  # keeper refuses to start without a config. Bake a minimal single-node config:
  # client port 9181 + raft 9234, listen on 0.0.0.0, log/snapshot storage under
  # the writable /tmp mkImage provides. A single-node raft elects itself leader,
  # so it comes up with no external deps. Operators mount a multi-node config.
  keeperConfig = pkgs.writeTextDir "etc/clickhouse-keeper/keeper_config.xml" ''
    <clickhouse>
        <logger><level>information</level><console>true</console></logger>
        <listen_host>0.0.0.0</listen_host>
        <keeper_server>
            <tcp_port>9181</tcp_port>
            <server_id>1</server_id>
            <log_storage_path>/tmp/clickhouse-keeper/log</log_storage_path>
            <snapshot_storage_path>/tmp/clickhouse-keeper/snapshots</snapshot_storage_path>
            <coordination_settings>
                <operation_timeout_ms>10000</operation_timeout_ms>
                <session_timeout_ms>30000</session_timeout_ms>
            </coordination_settings>
            <raft_configuration>
                <server><id>1</id><hostname>localhost</hostname><port>9234</port></server>
            </raft_configuration>
        </keeper_server>
    </clickhouse>
  '';

  entrypoint = pkgs.writeShellApplication {
    name = "docker-entrypoint.sh";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      mkdir -p /tmp/clickhouse-keeper/log /tmp/clickhouse-keeper/snapshots
      exec ${drv}/bin/clickhouse-keeper --config-file=/etc/clickhouse-keeper/keeper_config.xml "$@"
    '';
  };
in mkImage {
  inherit drv;
  name = "clickhouse-keeper";
  tag = "v${version}";
  entrypoint = [ "${entrypoint}/bin/docker-entrypoint.sh" ];
  cmd = [ ];

  extraPkgs = [ keeperConfig ];

  labels = {
    "org.opencontainers.image.title" = "clickhouse-keeper";
    "org.opencontainers.image.description" = "ZooKeeper-compatible coordination service for ClickHouse";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-binary";
  };
}
