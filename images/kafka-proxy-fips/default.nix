{ mkImage, pkgs, lib, ... }:

# kafka-proxy-fips — built from the upstream release artifact (#618).
let
  version = "0.4.3";
  src = pkgs.fetchurl { url = "https://github.com/grepplabs/kafka-proxy/releases/download/v0.4.3/kafka-proxy-v0.4.3-linux-amd64.tar.gz"; hash = "sha256-FoxAUAWbn3NEMt2j2lO+tUi5ScZcRaqvgEkNfb1GSTs="; };
  drv = pkgs.runCommand "kafka-proxy-fips-0.4.3" { nativeBuildInputs = [ pkgs.gnutar pkgs.gzip pkgs.unzip ]; } ''
    mkdir -p $out/bin extract
    tar xzf ${src} -C extract
    chmod -R +x extract 2>/dev/null || true
    f=$(find extract -type f -name 'kafka-proxy' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -name 'kafka-proxy*' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -perm -u+x | head -1)
    [ -z "$f" ] && f=$(find extract -type f | head -1)
    install -m755 "$f" $out/bin/kafka-proxy
  '';
in
mkImage {
  drv = drv;
  name = "kafka-proxy-fips";
  tag = "0.4.3";
  entrypoint = [ "${drv}/bin/kafka-proxy" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = "0.4.3";
    "org.opencontainers.image.description" = "kafka-proxy-fips (built from upstream release 0.4.3)";
  };
}
