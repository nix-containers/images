{ mkImage, pkgs, lib, ... }:

# Elastic APM Server - upstream Go APM ingestion server
# https://github.com/elastic/apm-server
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "9.5.3";

  drv = pkgs.buildGoModule {
    pname = "apm-server";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "elastic";
      repo = "apm-server";
      rev = "v${version}";
      hash = "sha256-5UTWAnuCDJfAOTHSylXaVIUWbau34k4S0a0H0iB2Vzk=";
    };

    proxyVendor = true;
    vendorHash = "sha256-oMCUkzNj/xl/8MX3iKIZZwgpVJAHuPLvRMksvsk3ejQ=";

    subPackages = [ "cmd/apm-server" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };

  # apm-server needs a minimal config; bake one that binds the intake on
  # 0.0.0.0:8200 and routes everything to the console output so the image
  # starts with no Elasticsearch dependency. Operators mount their own
  # config (output.elasticsearch + a real host/auth).
  apmConfig = pkgs.writeTextDir "etc/apm-server/apm-server.yml" ''
    apm-server:
      host: "0.0.0.0:8200"

    output.console:
      pretty: false
  '';
in mkImage {
  inherit drv;
  name = "apm-server";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/apm-server" ];
  cmd = [
    "-e"
    "-c" "/etc/apm-server/apm-server.yml"
    "--path.data" "/tmp/apm-server"
  ];

  extraPkgs = [ apmConfig ];
  labels = {
    "org.opencontainers.image.title" = "apm-server";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
