{ mkImage, pkgs, lib, ... }:

# Prometheus PgBouncer Exporter
# https://github.com/prometheus-community/pgbouncer_exporter

mkImage {
  drv = pkgs.prometheus-pgbouncer-exporter;
  name = "prometheus-pgbouncer-exporter";
  tag = "v${pkgs.prometheus-pgbouncer-exporter.version}";
  entrypoint = [ "${pkgs.prometheus-pgbouncer-exporter}/bin/pgbouncer_exporter" ];
  # Was `--help` (a one-shot). Serve /metrics on 0.0.0.0:9127 with a default
  # connection string. sql.Open is lazy, so the exporter connects to PgBouncer
  # only on scrape — it starts standalone. Operators point it at a real
  # PgBouncer via --pgBouncer.connectionString.
  cmd = [
    "--pgBouncer.connectionString=postgres://localhost:6432/pgbouncer?sslmode=disable"
    "--web.listen-address=0.0.0.0:9127"
  ];

  extraPkgs = with pkgs; [ cacert ];

  labels = {
    "org.opencontainers.image.title" = "Prometheus PgBouncer Exporter";
    "org.opencontainers.image.description" = "Prometheus exporter for PgBouncer metrics";
    "org.opencontainers.image.version" = pkgs.prometheus-pgbouncer-exporter.version;
    "io.nix-containers.image.upstream" = "https://github.com/prometheus-community/pgbouncer_exporter";
    "io.nix-containers.image.category" = "monitoring";
    "io.nix-containers.image.aliases" = "pgbouncer-exporter,pgbouncer_exporter,prometheus";
  };
}
