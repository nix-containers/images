{ mkImage, pkgs, lib, ... }:
# redpanda — packaged from nixpkgs pkgs.redpanda (#618).
mkImage {
  drv = pkgs.redpanda;
  name = "redpanda";
  tag = pkgs.redpanda.version;
  entrypoint = [ "${pkgs.redpanda}/bin/redpanda" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = pkgs.redpanda.version;
    "org.opencontainers.image.description" = "redpanda (nixpkgs redpanda)";
  };
}
