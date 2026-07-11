{ mkImage, pkgs, lib, ... }:

# cis-operator — built from the upstream release artifact (#618).
let
  version = "1.4.9-rc.1";
  src = pkgs.fetchurl { url = "https://github.com/rancher/cis-operator/releases/download/v1.4.8/cis-operator-amd64"; hash = "sha256-V/0MdGchBTKZzeAdmD4w6f83xEBew3qUGPutbXNEHf4="; };
  drv = pkgs.runCommand "cis-operator-1.4.8" { nativeBuildInputs = [ pkgs.gnutar pkgs.gzip pkgs.unzip ]; } ''
    mkdir -p $out/bin extract
    cp ${src} extract/cis-operator
    chmod -R +x extract 2>/dev/null || true
    f=$(find extract -type f -name 'cis-operator' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -name 'cis-operator*' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -perm -u+x | head -1)
    [ -z "$f" ] && f=$(find extract -type f | head -1)
    install -m755 "$f" $out/bin/cis-operator
  '';
in
mkImage {
  drv = drv;
  name = "cis-operator";
  tag = "1.4.8";
  entrypoint = [ "${drv}/bin/cis-operator" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = "1.4.8";
    "org.opencontainers.image.description" = "cis-operator (built from upstream release v1.4.8)";
  };
}
