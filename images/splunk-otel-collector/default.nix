{ mkImage, pkgs, lib, ... }:

# Splunk OpenTelemetry Collector
# https://github.com/signalfx/splunk-otel-collector
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "0.155.0";

  drv = pkgs.buildGoModule {
    pname = "splunk-otel-collector";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "signalfx";
      repo = "splunk-otel-collector";
      rev = "v${version}";
      hash = "sha256-nEDeNZchzeoinK9VPGL6k0+iGWiKkKLMk9YvEbZFooU=";
    };

    proxyVendor = true;
    vendorHash = "sha256-JQkrotVGnqcq23gyVfF32mXpS2BcduOLPdYmHPDanXc=";

    subPackages = [ "cmd/otelcol" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
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
    "io.nix-containers.source" = "upstream-source";
  };
}
