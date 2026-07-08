{ mkImage, pkgs, lib, ... }:

# azure-ipam — built from the upstream release artifact (#618).
let
  version = "0.4.0";
  src = pkgs.fetchurl { url = "https://github.com/Azure/azure-container-networking/releases/download/azure-ipam/v0.4.0/azure-ipam-linux-amd64-v0.4.0.tgz"; hash = "sha256-Or5292LHMKueQPFWdgnLNaDwch6sClvVkunDsNBLLPc="; };
  drv = pkgs.runCommand "azure-ipam-0.4.0" { nativeBuildInputs = [ pkgs.gnutar pkgs.gzip pkgs.unzip ]; } ''
    mkdir -p $out/bin extract
    tar xzf ${src} -C extract
    chmod -R +x extract 2>/dev/null || true
    f=$(find extract -type f -name 'azure-ipam' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -name 'azure-ipam*' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -perm -u+x | head -1)
    [ -z "$f" ] && f=$(find extract -type f | head -1)
    install -m755 "$f" $out/bin/azure-ipam
  '';
in
mkImage {
  drv = drv;
  name = "azure-ipam";
  tag = "0.4.0";
  entrypoint = [ "${drv}/bin/azure-ipam" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = "0.4.0";
    "org.opencontainers.image.description" = "azure-ipam (built from upstream release v0.4.0)";
  };
}
