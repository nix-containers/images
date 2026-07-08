{ mkImage, pkgs, lib, ... }:

# k8ssandra-client-fips — built from the upstream release artifact (#618).
let
  version = "0.8.14";
  src = pkgs.fetchurl { url = "https://github.com/k8ssandra/k8ssandra-client/releases/download/v0.8.14/k8ssandra-client_0.8.14_linux_amd64.tar.gz"; hash = "sha256-TBQda6GoxP4iSbSRZGtPnnv8QFx+Tg6Y9zcskVRRcHg="; };
  drv = pkgs.runCommand "k8ssandra-client-fips-0.8.14" { nativeBuildInputs = [ pkgs.gnutar pkgs.gzip pkgs.unzip ]; } ''
    mkdir -p $out/bin extract
    tar xzf ${src} -C extract
    chmod -R +x extract 2>/dev/null || true
    f=$(find extract -type f -name 'k8ssandra-client' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -name 'k8ssandra-client*' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -perm -u+x | head -1)
    [ -z "$f" ] && f=$(find extract -type f | head -1)
    install -m755 "$f" $out/bin/k8ssandra-client
  '';
in
mkImage {
  drv = drv;
  name = "k8ssandra-client-fips";
  tag = "0.8.14";
  entrypoint = [ "${drv}/bin/k8ssandra-client" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = "0.8.14";
    "org.opencontainers.image.description" = "k8ssandra-client-fips (built from upstream release v0.8.14)";
  };
}
