{ mkImage, pkgs, lib, ... }:

# spire-oidc-discovery-provider — built from the upstream release artifact (#618).
let
  version = "1.15.2";
  src = pkgs.fetchurl { url = "https://github.com/spiffe/spire/releases/download/v1.6.2/spire-extras-1.6.2-linux-x86_64-glibc.tar.gz"; hash = "sha256-v14AZYja/8ZiDOT1PkdpQroK2fKSka5MYPhfwboFj1k="; };
  drv = pkgs.runCommand "spire-oidc-discovery-provider-1.6.2" { nativeBuildInputs = [ pkgs.gnutar pkgs.gzip pkgs.unzip ]; } ''
    mkdir -p $out/bin extract
    tar xzf ${src} -C extract
    chmod -R +x extract 2>/dev/null || true
    f=$(find extract -type f -name 'oidc-discovery-provider' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -name 'oidc-discovery-provider*' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -perm -u+x | head -1)
    [ -z "$f" ] && f=$(find extract -type f | head -1)
    install -m755 "$f" $out/bin/oidc-discovery-provider
  '';
in
mkImage {
  drv = drv;
  name = "spire-oidc-discovery-provider";
  tag = "1.6.2";
  entrypoint = [ "${drv}/bin/oidc-discovery-provider" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = "1.6.2";
    "org.opencontainers.image.description" = "spire-oidc-discovery-provider (built from upstream release 1.6.2)";
  };
}
