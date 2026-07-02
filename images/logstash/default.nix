{ mkImage, pkgs, lib, ... }:

# Logstash - Server-side data processing pipeline
# https://www.elastic.co/logstash
#
# nixpkgs.logstash is pinned to the 7.17 line, whose bundled Java deps
# (jackson/log4j/netty/…) carry critical CVEs. Package the current 9.x
# distribution (which ships its own JDK) directly from Elastic.

let
  version = "9.4.3";

  logstash = pkgs.stdenv.mkDerivation {
    pname = "logstash";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://artifacts.elastic.co/downloads/logstash/logstash-${version}-linux-x86_64.tar.gz";
      hash = "sha256-D/beWoHk3Fn+8TIRvUmms7V2ma7UZ0M5CNFN/XF+v7A=";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook pkgs.makeWrapper ];
    # The bundled JDK + native libs link against these; anything else the
    # JDK dlopens is resolved at runtime.
    buildInputs = [ pkgs.stdenv.cc.cc.lib pkgs.zlib ];
    autoPatchelfIgnoreMissingDeps = true;

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/opt/logstash" "$out/bin"
      cp -r . "$out/opt/logstash"
      # bin/logstash locates and uses the bundled jdk/ automatically.
      makeWrapper "$out/opt/logstash/bin/logstash" "$out/bin/logstash"
      runHook postInstall
    '';

    meta.mainProgram = "logstash";
  };

  # Minimal pipeline so the server runs with no args (the old cmd was `--help`,
  # a one-shot -> the kind-test pod CrashLoops). A `heartbeat` input (core
  # plugin, no deps) feeds `stdout`, which keeps the pipeline — and the process
  # — running. Operators mount their own pipeline at /etc/logstash/pipeline.conf
  # (or pass -f their own path).
  pipelineConfig = pkgs.writeTextDir "etc/logstash/pipeline.conf" ''
    input {
      heartbeat {
        interval => 60
        message => "ok"
      }
    }
    output {
      stdout { codec => rubydebug }
    }
  '';

in
mkImage {
  drv = logstash;
  name = "logstash";
  tag = "v${version}";
  entrypoint = [ "${logstash}/bin/logstash" ];
  # Run the baked pipeline. Data + logs go on the writable /tmp mkImage provides
  # (the dist dirs are read-only nix store); expose the monitoring API on all
  # interfaces so the kind-test probe can reach it.
  cmd = [
    "-f" "/etc/logstash/pipeline.conf"
    "--path.data" "/tmp/logstash-data"
    "--path.logs" "/tmp/logstash-logs"
    "--api.http.host" "0.0.0.0"
  ];

  extraPkgs = with pkgs; [ cacert bash coreutils pipelineConfig ];

  env = {
    # Keep the JVM small so it fits the CI runner (mirrors the elasticsearch
    # image); the pipeline only needs to launch and stay up.
    LS_JAVA_OPTS = "-Xms512m -Xmx512m";
  };

  labels = {
    "org.opencontainers.image.title" = "Logstash";
    "org.opencontainers.image.description" = "Server-side data processing pipeline for ingesting data";
    "org.opencontainers.image.version" = version;
  };
}
