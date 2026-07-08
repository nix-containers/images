{ mkImage, pkgs, lib, ... }:

# kafka-exporter — built from the upstream release artifact (#618).
let
  version = "1.9.0";
  src = pkgs.fetchurl { url = "https://github.com/danielqsj/kafka_exporter/releases/download/v1.9.0/kafka_exporter-1.9.0.linux-amd64.tar.gz"; hash = "sha256-xyJRitccU7OYjqJq4r04e7WWznqY/GOdCL9jmlN2maE="; };
  drv = pkgs.runCommand "kafka-exporter-1.9.0" { nativeBuildInputs = [ pkgs.gnutar pkgs.gzip pkgs.unzip ]; } ''
    mkdir -p $out/bin extract
    tar xzf ${src} -C extract
    chmod -R +x extract 2>/dev/null || true
    f=$(find extract -type f -name 'kafka_exporter' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -name 'kafka_exporter*' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -perm -u+x | head -1)
    [ -z "$f" ] && f=$(find extract -type f | head -1)
    install -m755 "$f" $out/bin/kafka_exporter
  '';
in
mkImage {
  drv = drv;
  name = "kafka-exporter";
  tag = "1.9.0";
  entrypoint = [ "${drv}/bin/kafka_exporter" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = "1.9.0";
    "org.opencontainers.image.description" = "kafka-exporter (built from upstream release v1.9.0)";
  };
}
