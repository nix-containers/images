{ mkImage, pkgs, lib, ... }:

# Grafana Mimir (-fips image variant)
# -fips variant packages the same upstream mimir binary (no FIPS claim made).
# https://github.com/grafana/mimir
#
# Uses pkgs.mimir (built from source via nixpkgs + the flake.nix overlay
# that pins the current upstream release). This keeps Go-stdlib CVEs
# clearing on each rebuild.
let
  drv = pkgs.mimir;
  version = drv.version;
in mkImage {
  inherit drv;
  name = "grafana-mimir-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/mimir" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "grafana-mimir-fips";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "nixpkgs";
  };
}
