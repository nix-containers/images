{ mkImage, pkgs, lib, ... }:

# timestamp-authority-cli — built from the upstream release artifact (#618).
let
  version = "2.1.3";
  src = pkgs.fetchurl { url = "https://github.com/sigstore/timestamp-authority/releases/download/v2.1.3/timestamp-cli-linux-amd64"; hash = "sha256-ABvw73RyMhd2SmDpI6WXJNi6DmQqVlzijaLKxpoJUOo="; };
  drv = pkgs.runCommand "timestamp-authority-cli-2.1.3" { nativeBuildInputs = [ pkgs.gnutar pkgs.gzip pkgs.unzip ]; } ''
    mkdir -p $out/bin extract
    cp ${src} extract/timestamp-cli
    chmod -R +x extract 2>/dev/null || true
    f=$(find extract -type f -name 'timestamp-cli' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -name 'timestamp-cli*' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -perm -u+x | head -1)
    [ -z "$f" ] && f=$(find extract -type f | head -1)
    install -m755 "$f" $out/bin/timestamp-cli
  '';
in
mkImage {
  drv = drv;
  name = "timestamp-authority-cli";
  tag = "2.1.3";
  entrypoint = [ "${drv}/bin/timestamp-cli" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = "2.1.3";
    "org.opencontainers.image.description" = "timestamp-authority-cli (built from upstream release v2.1.3)";
  };
}
