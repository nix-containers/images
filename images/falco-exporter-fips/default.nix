{ mkImage, pkgs, lib, ... }:

# falco-exporter-fips — built from the upstream release artifact (#618).
let
  version = "0.8.7";
  src = pkgs.fetchurl { url = "https://github.com/falcosecurity/falco-exporter/releases/download/v0.8.7/falco-exporter_0.8.7_linux_amd64.tar.gz"; hash = "sha256-w/sLK4YGPT4suLaD8LktLzGHu8D7eXv3ImMNuNZ1DV4="; };
  drv = pkgs.runCommand "falco-exporter-fips-0.8.7" { nativeBuildInputs = [ pkgs.gnutar pkgs.gzip pkgs.unzip ]; } ''
    mkdir -p $out/bin extract
    tar xzf ${src} -C extract
    chmod -R +x extract 2>/dev/null || true
    f=$(find extract -type f -name 'falco-exporter' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -name 'falco-exporter*' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -perm -u+x | head -1)
    [ -z "$f" ] && f=$(find extract -type f | head -1)
    install -m755 "$f" $out/bin/falco-exporter
  '';
in
mkImage {
  drv = drv;
  name = "falco-exporter-fips";
  tag = "0.8.7";
  entrypoint = [ "${drv}/bin/falco-exporter" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = "0.8.7";
    "org.opencontainers.image.description" = "falco-exporter-fips (built from upstream release 0.8.7)";
  };
}
