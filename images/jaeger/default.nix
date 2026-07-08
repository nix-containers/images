{ mkImage, pkgs, lib, ... }:

# jaeger — built from the upstream release artifact (#618).
let
  version = "1.76.0";
  src = pkgs.fetchurl { url = "https://github.com/jaegertracing/jaeger/releases/download/v1.76.0/jaeger-1.76.0-linux-amd64.tar.gz"; hash = "sha256-yrPq0GqDfuUZwWpDlLMj5YtmtPL4+CwNsN+4EDXe9y4="; };
  drv = pkgs.runCommand "jaeger-1.76.0" { nativeBuildInputs = [ pkgs.gnutar pkgs.gzip pkgs.unzip ]; } ''
    mkdir -p $out/bin extract
    tar xzf ${src} -C extract
    chmod -R +x extract 2>/dev/null || true
    f=$(find extract -type f -name 'jaeger-all-in-one' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -name 'jaeger-all-in-one*' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -perm -u+x | head -1)
    [ -z "$f" ] && f=$(find extract -type f | head -1)
    install -m755 "$f" $out/bin/jaeger-all-in-one
  '';
in
mkImage {
  drv = drv;
  name = "jaeger";
  tag = "1.76.0";
  entrypoint = [ "${drv}/bin/jaeger-all-in-one" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = "1.76.0";
    "org.opencontainers.image.description" = "jaeger (built from upstream release 1.76.0)";
  };
}
