{ mkImage, pkgs, lib, ... }:

# loki-3.6-promtail — built from the upstream release artifact (#618).
let
  version = "3.6.11";
  src = pkgs.fetchurl { url = "https://github.com/grafana/loki/releases/download/v3.6.11/promtail-linux-amd64.zip"; hash = "sha256-+H1yNYUxzHAIojZnzGjMcm51EVzQiClQchXkm0ypIew="; };
  drv = pkgs.runCommand "loki-3.6-promtail-3.6.11" { nativeBuildInputs = [ pkgs.gnutar pkgs.gzip pkgs.unzip ]; } ''
    mkdir -p $out/bin extract
    unzip -o ${src} -d extract
    chmod -R +x extract 2>/dev/null || true
    f=$(find extract -type f -name 'promtail' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -name 'promtail*' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -perm -u+x | head -1)
    [ -z "$f" ] && f=$(find extract -type f | head -1)
    install -m755 "$f" $out/bin/promtail
  '';
in
mkImage {
  drv = drv;
  name = "loki-3.6-promtail";
  tag = "3.6.11";
  entrypoint = [ "${drv}/bin/promtail" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = "3.6.11";
    "org.opencontainers.image.description" = "loki-3.6-promtail (built from upstream release 3.6.11)";
  };
}
