{ mkImage, pkgs, lib, ... }:

# newrelic-infrastructure-agent — built from the upstream release artifact (#618).
let
  version = "1.77.1";
  src = pkgs.fetchurl { url = "https://github.com/newrelic/infrastructure-agent/releases/download/1.77.1/newrelic-infra_linux_1.77.1_amd64.tar.gz"; hash = "sha256-az8ivGNI57L0JDSLTGGH/VVrfuwLbklRGk2QPhdjA6c="; };
  drv = pkgs.runCommand "newrelic-infrastructure-agent-1.77.1" { nativeBuildInputs = [ pkgs.gnutar pkgs.gzip pkgs.unzip ]; } ''
    mkdir -p $out/bin extract
    tar xzf ${src} -C extract
    chmod -R +x extract 2>/dev/null || true
    f=$(find extract -type f -name 'newrelic-infra' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -name 'newrelic-infra*' | head -1)
    [ -z "$f" ] && f=$(find extract -type f -perm -u+x | head -1)
    [ -z "$f" ] && f=$(find extract -type f | head -1)
    install -m755 "$f" $out/bin/newrelic-infra
  '';
in
mkImage {
  drv = drv;
  name = "newrelic-infrastructure-agent";
  tag = "1.77.1";
  entrypoint = [ "${drv}/bin/newrelic-infra" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = "1.77.1";
    "org.opencontainers.image.description" = "newrelic-infrastructure-agent (built from upstream release 1.77.1)";
  };
}
