{ mkImage, pkgs, lib, ... }:

# timestamp-authority-server — built from the upstream release artifact (#618).
let
  version = "2.1.3";
  src = pkgs.fetchurl { url = "https://github.com/sigstore/timestamp-authority/releases/download/v2.1.3/timestamp-server-linux-amd64"; hash = "sha256-GraLrLjlEgWnIuOkmiyJ1iB34bw/VYwibtfkWO9UBKc="; };
  drv = pkgs.runCommand "timestamp-authority-server-2.1.3" { nativeBuildInputs = [ pkgs.gnutar pkgs.gzip pkgs.unzip ]; } ''
    mkdir -p $out/bin extract
    cp ${src} extract/timestamp-server
    chmod -R +x extract 2>/dev/null || true
    f=$(find extract -type f -name 'timestamp-server' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -name 'timestamp-server*' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -perm -u+x | head -1)
    [ -z "$f" ] && f=$(find extract -type f | head -1)
    install -m755 "$f" $out/bin/timestamp-server
  '';
in
mkImage {
  drv = drv;
  name = "timestamp-authority-server";
  tag = "2.1.3";
  entrypoint = [ "${drv}/bin/timestamp-server" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = "2.1.3";
    "org.opencontainers.image.description" = "timestamp-authority-server (built from upstream release v2.1.3)";
  };
}
