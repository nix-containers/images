{ mkImage, pkgs, lib, ... }:

# vela-cli — built from the upstream release artifact (#618).
let
  version = "1.10.9";
  src = pkgs.fetchurl { url = "https://github.com/kubevela/kubevela/releases/download/v1.10.9/vela-v1.10.9-linux-amd64.tar.gz"; hash = "sha256-MhMNgBKP1UX7aYfG8Pzi8buzieY2NuUSZ1tBZE9qYKE="; };
  drv = pkgs.runCommand "vela-cli-1.10.9" { nativeBuildInputs = [ pkgs.gnutar pkgs.gzip pkgs.unzip ]; } ''
    mkdir -p $out/bin extract
    tar xzf ${src} -C extract
    chmod -R +x extract 2>/dev/null || true
    f=$(find extract -type f -name 'vela' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -name 'vela*' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -perm -u+x | head -1)
    [ -z "$f" ] && f=$(find extract -type f | head -1)
    install -m755 "$f" $out/bin/vela
  '';
in
mkImage {
  drv = drv;
  name = "vela-cli";
  tag = "1.10.9";
  entrypoint = [ "${drv}/bin/vela" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = "1.10.9";
    "org.opencontainers.image.description" = "vela-cli (built from upstream release v1.10.9)";
  };
}
