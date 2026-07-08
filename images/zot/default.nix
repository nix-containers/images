{ mkImage, pkgs, lib, ... }:

# zot — built from the upstream release artifact (#618).
let
  version = "2.1.18";
  src = pkgs.fetchurl { url = "https://github.com/project-zot/zot/releases/download/v2.1.18/zot-linux-amd64"; hash = "sha256-o1mgrxWdtnWLJPjibWokSq6VyvP/OCxGKHX0LZ4IKJg="; };
  drv = pkgs.runCommand "zot-2.1.18" { nativeBuildInputs = [ pkgs.gnutar pkgs.gzip pkgs.unzip ]; } ''
    mkdir -p $out/bin extract
    cp ${src} extract/zot
    chmod -R +x extract 2>/dev/null || true
    f=$(find extract -type f -name 'zot' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -name 'zot*' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -perm -u+x | head -1)
    [ -z "$f" ] && f=$(find extract -type f | head -1)
    install -m755 "$f" $out/bin/zot
  '';
in
mkImage {
  drv = drv;
  name = "zot";
  tag = "2.1.18";
  entrypoint = [ "${drv}/bin/zot" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = "2.1.18";
    "org.opencontainers.image.description" = "zot (built from upstream release v2.1.18)";
  };
}
