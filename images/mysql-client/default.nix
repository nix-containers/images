{ mkImage, pkgs, lib, ... }:
# mysql-client — packaged from nixpkgs pkgs.mysql-client (#618).
mkImage {
  drv = pkgs.mysql-client;
  name = "mysql-client";
  tag = pkgs.mysql-client.version;
  entrypoint = [ "${pkgs.mysql-client}/bin/mysql-client" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = pkgs.mysql-client.version;
    "org.opencontainers.image.description" = "mysql-client (nixpkgs mysql-client)";
  };
}
