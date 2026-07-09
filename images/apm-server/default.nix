{ mkImage, pkgs, lib, ... }:

# Elastic APM Server - upstream Go APM ingestion server
# https://github.com/elastic/apm-server
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "9.4.2";

  drv = pkgs.buildGoModule {
    pname = "apm-server";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "elastic";
      repo = "apm-server";
      rev = "v${version}";
      hash = "sha256-HCdIWiqkj2/385Lfa6Un7/8HT7o4i4S6NjvrZfP/LB4=";
    };

    proxyVendor = true;
    vendorHash = "sha256-EDYlW3qU4rUx3X0KCdTk7nBPl1jXSBbzz9GlR2+fpnk=";

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
