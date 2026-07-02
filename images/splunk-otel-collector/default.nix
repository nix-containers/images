{ mkImage, pkgs, lib, ... }:

# Splunk OpenTelemetry Collector
# https://github.com/signalfx/splunk-otel-collector

let
  version = "0.154.2";

  drv = pkgs.stdenv.mkDerivation {
    pname = "splunk-otel-collector";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/signalfx/splunk-otel-collector/releases/download/v${version}/otelcol_linux_amd64";
      hash = "sha256:19jq6mgkxklblz24svglj0wy7cw5qjj1h91k5zgag9dvspwb2zcr";
    };

    dontUnpack = true;

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.stdenv.cc.cc.lib ];

    installPhase = ''
      runHook preInstall
      install -Dm755 $src $out/bin/otelcol
      runHook postInstall
    '';
  };

  # The old cmd was `--help` (a one-shot -> the kind-test pod CrashLoops), and
  # otelcol refuses to start without a config. Bake a minimal, self-contained
  # pipeline: an OTLP receiver on 0.0.0.0:4317 (gRPC) + :4318 (HTTP) feeding a
  # debug exporter (in-memory, no writable dir / external deps). Operators mount
  # their own config (or set SPLUNK_* env) for real exporters.
  otelConfig = pkgs.writeTextDir "etc/otelcol/config.yaml" ''
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: 0.0.0.0:4317
          http:
            endpoint: 0.0.0.0:4318
    exporters:
      debug:
        verbosity: basic
    service:
      pipelines:
        traces:
          receivers: [otlp]
          exporters: [debug]
        metrics:
          receivers: [otlp]
          exporters: [debug]
        logs:
          receivers: [otlp]
          exporters: [debug]
  '';
in mkImage {
  inherit drv;
  name = "splunk-otel-collector";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/otelcol" ];
  cmd = [ "--config=/etc/otelcol/config.yaml" ];

  extraPkgs = [ otelConfig ];
  labels = {
    "org.opencontainers.image.title" = "splunk-otel-collector";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-binary";
  };
}
