{ mkImage, pkgs, lib, ... }:

# whereabouts — built from the upstream release artifact (#618).
let
  version = "0.6.1";
  src = pkgs.fetchurl { url = "https://github.com/k8snetworkplumbingwg/whereabouts/releases/download/v0.6.1/whereabouts-amd64"; hash = "sha256-vcc0dofhWa9n+pTPpM+6K4CGxSNcCx2lCaxJ7yyrw+8="; };
  drv = pkgs.runCommand "whereabouts-0.6.1" { nativeBuildInputs = [ pkgs.gnutar pkgs.gzip pkgs.unzip ]; } ''
    mkdir -p $out/bin extract
    cp ${src} extract/whereabouts
    chmod -R +x extract 2>/dev/null || true
    f=$(find extract -type f -name 'whereabouts' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -name 'whereabouts*' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -perm -u+x | head -1)
    [ -z "$f" ] && f=$(find extract -type f | head -1)
    install -m755 "$f" $out/bin/whereabouts
  '';
in
mkImage {
  drv = drv;
  name = "whereabouts";
  tag = "0.6.1";
  entrypoint = [ "${drv}/bin/whereabouts" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = "0.6.1";
    "org.opencontainers.image.description" = "whereabouts (built from upstream release v0.6.1)";
  };
}
