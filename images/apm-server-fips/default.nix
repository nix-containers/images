{ mkImage, pkgs, lib, ... }:

# Elastic APM Server (-fips variant) - built from source
# https://github.com/elastic/apm-server
# -fips suffix packages the upstream binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "9.4.2";

  drv = pkgs.buildGoModule {
    pname = "apm-server-fips";
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

  apmConfig = pkgs.writeTextDir "etc/apm-server/apm-server.yml" ''
    apm-server:
      host: "0.0.0.0:8200"

    output.console:
      pretty: false
  '';
in mkImage {
  inherit drv;
  name = "apm-server-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/apm-server" ];
  cmd = [
    "-e"
    "-c" "/etc/apm-server/apm-server.yml"
    "--path.data" "/tmp/apm-server"
  ];

  extraPkgs = [ apmConfig ];
  labels = {
    "org.opencontainers.image.title" = "apm-server-fips";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
