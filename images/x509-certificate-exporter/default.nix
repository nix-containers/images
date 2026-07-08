{ mkImage, pkgs, lib, ... }:

# x509-certificate-exporter — built from the upstream release artifact (#618).
let
  version = "4.1.0";
  src = pkgs.fetchurl { url = "https://github.com/enix/x509-certificate-exporter/releases/download/v4.1.0/x509-certificate-exporter-v4.1.0-linux-amd64.tar.gz"; hash = "sha256-u6+fTYbslmrQMTNXeutaKPHFoLRyCGncSRfSXqo5qZw="; };
  drv = pkgs.runCommand "x509-certificate-exporter-4.1.0" { nativeBuildInputs = [ pkgs.gnutar pkgs.gzip pkgs.unzip ]; } ''
    mkdir -p $out/bin extract
    tar xzf ${src} -C extract
    chmod -R +x extract 2>/dev/null || true
    f=$(find extract -type f -name 'x509-certificate-exporter' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -name 'x509-certificate-exporter*' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -perm -u+x | head -1)
    [ -z "$f" ] && f=$(find extract -type f | head -1)
    install -m755 "$f" $out/bin/x509-certificate-exporter
  '';
in
mkImage {
  drv = drv;
  name = "x509-certificate-exporter";
  tag = "4.1.0";
  entrypoint = [ "${drv}/bin/x509-certificate-exporter" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = "4.1.0";
    "org.opencontainers.image.description" = "x509-certificate-exporter (built from upstream release 4.1.0)";
  };
}
