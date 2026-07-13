{ mkImage, pkgs, lib, ... }:

# Prometheus SQL Exporter (-fips variant)
# https://github.com/burningalchemist/sql_exporter
# -fips variant packages the upstream binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.
let
  version = "0.24.3";
  drv = pkgs.buildGoModule {
    pname = "sql_exporter";
    inherit version;
    src = pkgs.fetchFromGitHub {
      owner = "burningalchemist";
      repo = "sql_exporter";
      rev = version;
      hash = "sha256-xyaP9mR2We4Js8jfQpbaANihGDjrB0s2T91UMOYeKCg=";
    };

    proxyVendor = true;
    vendorHash = "sha256-RoCz0BqdwYUmGh2XDK367k81qVnzGGw9lYidmLPp1O8=";

    subPackages = [ "cmd/sql_exporter" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "sql_exporter-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/sql_exporter" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "sql_exporter-fips";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
