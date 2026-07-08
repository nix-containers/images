{ mkImage, pkgs, lib, ... }:

# flannel-cni-plugin — built from the upstream release artifact (#618).
let
  version = "1.5.1-flannel1";
  src = pkgs.fetchurl { url = "https://github.com/flannel-io/cni-plugin/releases/download/v1.5.1-flannel1/flannel-amd64"; hash = "sha256-CLFvAXJuv5lLu61Ur918hhrsmaDl+2SkKv0T+z2UX88="; };
  drv = pkgs.runCommand "flannel-cni-plugin-1.5.1-flannel1" { nativeBuildInputs = [ pkgs.gnutar pkgs.gzip pkgs.unzip ]; } ''
    mkdir -p $out/bin extract
    cp ${src} extract/flannel
    chmod -R +x extract 2>/dev/null || true
    f=$(find extract -type f -name 'flannel' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -name 'flannel*' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -perm -u+x | head -1)
    [ -z "$f" ] && f=$(find extract -type f | head -1)
    install -m755 "$f" $out/bin/flannel
  '';
in
mkImage {
  drv = drv;
  name = "flannel-cni-plugin";
  tag = "1.5.1-flannel1";
  entrypoint = [ "${drv}/bin/flannel" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = "1.5.1-flannel1";
    "org.opencontainers.image.description" = "flannel-cni-plugin (built from upstream release v1.5.1-flannel1)";
  };
}
