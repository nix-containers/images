# mattermost
# =============
# Mattermost - Open source platform for secure collaboration
# https://mattermost.com/

{ mkImage, pkgs, lib, ... }:

# Use pkgs.mattermostLatest (currently v11.8.2) rather than pkgs.mattermost
# (11.7.x ESR line). Nixpkgs' own update script tracks the latest non-ESR
# release for mattermostLatest, so our flake.lock bump workflow picks up
# future 11.8.x → 11.9.x moves automatically.

let
  mm = pkgs.mattermostLatest;
in
mkImage {
  drv = mm;
  name = "mattermost";
  tag = mm.version;
  entrypoint = [ "${mm}/bin/mattermost" ];
  cmd = [ "server" ];

  extraPkgs = with pkgs; [ bash tzdata cacert ];

  env = {
    MM_DATA_DIR = "/mattermost/data";
    MM_CONFIG = "/mattermost/config/config.json";
  };

  labels = {
    "org.opencontainers.image.title" = "Mattermost";
    "org.opencontainers.image.description" = "Open source platform for secure collaboration";
    "org.opencontainers.image.version" = mm.version;
    "io.nix-containers.chart" = "mattermost";
  };
}
