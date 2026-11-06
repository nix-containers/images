{ mkImage, pkgs, lib, ... }:

# Prometheus exporter for Apache HTTP Server metrics
# https://github.com/Lusitaniae/apache_exporter
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "1.1.3";

  drv = pkgs.buildGoModule {
    pname = "apache_exporter";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "Lusitaniae";
      repo = "apache_exporter";
      rev = "v${version}";
      hash = "sha256-XhhQA65TA5FRbZLb5CKhpdU8zS69J08i95I+5uFs82A=";
    };

    proxyVendor = true;
    vendorHash = "sha256-MjD0iTM7YowzUjK9rifHkD1uBZnXRHe+ltCUGDaf8d4=";

    subPackages = [ "." ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "apache-exporter";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/apache_exporter" ];
  # Was `--help` (a one-shot, so the kind-test pod CrashLoops). Run the exporter
  # with its defaults: apache_exporter is pull-based, so it starts and serves
  # metrics on its default --web.listen-address :9117 (all interfaces) regardless
  # of whether the scraped Apache (default --scrape_uri
  # http://localhost/server-status/?auto) is reachable — it only scrapes on each
  # /metrics request. Operators set --scrape_uri to their Apache server-status.
  cmd = [];
  labels = {
    "org.opencontainers.image.title" = "apache-exporter";
    "org.opencontainers.image.description" = "Prometheus exporter for Apache HTTP Server metrics";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
