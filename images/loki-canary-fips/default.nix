{ mkImage, pkgs, lib, ... }:

# loki-canary - standalone Grafana Loki data-integrity canary
# https://github.com/grafana/loki
# -fips variant packages the upstream loki-canary binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "3.7.3";

  drv = pkgs.buildGoModule {
    pname = "loki-canary";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "grafana";
      repo = "loki";
      rev = "v${version}";
      hash = "sha256-2dqwnM2+9+P/ZIiz5Z9JPN9WicHLRzq9xn6jG1OBqLs=";
    };

    vendorHash = null;

    subPackages = [ "cmd/loki-canary" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "loki-canary-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/loki-canary" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "loki-canary";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
