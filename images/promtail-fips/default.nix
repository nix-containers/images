{ mkImage, pkgs, lib, ... }:
# promtail-fips — packaged from nixpkgs pkgs.promtail (#618).
mkImage {
  drv = pkgs.promtail;
  name = "promtail-fips";
  tag = pkgs.promtail.version;
  entrypoint = [ "${pkgs.promtail}/bin/promtail" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = pkgs.promtail.version;
    "org.opencontainers.image.description" = "promtail-fips (nixpkgs promtail)";
  };
}
