{ mkImage, pkgs, lib, ... }:

# yace — built from the upstream release artifact (#618).
let
  version = "0.67.0";
  src = pkgs.fetchurl { url = "https://github.com/prometheus-community/yet-another-cloudwatch-exporter/releases/download/v0.67.0/yet-another-cloudwatch-exporter-0.67.0.linux-amd64.tar.gz"; hash = "sha256-+LPnR0xuPcshJzNUfina6FHjmc6NZhCpy9h8RWY2tOc="; };
  drv = pkgs.runCommand "yace-0.67.0" { nativeBuildInputs = [ pkgs.gnutar pkgs.gzip pkgs.unzip ]; } ''
    mkdir -p $out/bin extract
    tar xzf ${src} -C extract
    chmod -R +x extract 2>/dev/null || true
    f=$(find extract -type f -name 'yace' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -name 'yace*' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -perm -u+x | head -1)
    [ -z "$f" ] && f=$(find extract -type f | head -1)
    install -m755 "$f" $out/bin/yace
  '';
in
mkImage {
  drv = drv;
  name = "yace";
  tag = "0.67.0";
  entrypoint = [ "${drv}/bin/yace" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = "0.67.0";
    "org.opencontainers.image.description" = "yace (built from upstream release v0.67.0)";
  };
}
