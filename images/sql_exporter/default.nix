{ mkImage, pkgs, lib, ... }:

# Prometheus SQL Exporter - https://github.com/burningalchemist/sql_exporter
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.
let
  version = "0.24.2";
  drv = pkgs.buildGoModule {
    pname = "sql_exporter";
    inherit version;
    src = pkgs.fetchFromGitHub {
      owner = "burningalchemist";
      repo = "sql_exporter";
      rev = version;
      hash = "sha256-imknv5/btSrKWHY85y4ng9+GKksyxwiMvTe2QaYv76U=";
    };

    proxyVendor = true;
    vendorHash = "sha256-c8OmXVA9zQ/pTR7XLhefHH4dDFoZrKHbf6Xg6EplCh4=";

    subPackages = [ "cmd/sql_exporter" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "sql_exporter";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/sql_exporter" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "sql_exporter";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
