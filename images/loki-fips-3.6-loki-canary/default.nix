{ mkImage, pkgs, lib, ... }:

# loki-fips-3.6-loki-canary — built from the upstream release artifact (#618).
let
  version = "3.7.3";
  src = pkgs.fetchurl { url = "https://github.com/grafana/loki/releases/download/v3.7.3/loki-canary-linux-amd64.zip"; hash = "sha256-OuGZ9tEwbTCQMXQI4GzsUBuCJyd5PooSswj3cYxRmd4="; };
  drv = pkgs.runCommand "loki-fips-3.6-loki-canary-3.7.3" { nativeBuildInputs = [ pkgs.gnutar pkgs.gzip pkgs.unzip ]; } ''
    mkdir -p $out/bin extract
    unzip -o ${src} -d extract
    chmod -R +x extract 2>/dev/null || true
    f=$(find extract -type f -name 'loki-canary' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -name 'loki-canary*' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -perm -u+x | head -1)
    [ -z "$f" ] && f=$(find extract -type f | head -1)
    install -m755 "$f" $out/bin/loki-canary
  '';
in
mkImage {
  drv = drv;
  name = "loki-fips-3.6-loki-canary";
  tag = "3.7.3";
  entrypoint = [ "${drv}/bin/loki-canary" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = "3.7.3";
    "org.opencontainers.image.description" = "loki-fips-3.6-loki-canary (built from upstream release 3.7.3)";
  };
}
