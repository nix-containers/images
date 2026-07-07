{ mkImage, pkgs, lib, ... }:

# Grafana Beyla - eBPF-based application auto-instrumentation tool
# https://github.com/grafana/beyla
let
  version = "3.25.0";
  drv = pkgs.stdenv.mkDerivation {
    pname = "grafana-beyla";
    inherit version;
    src = pkgs.fetchurl {
      url = "https://github.com/grafana/beyla/releases/download/v${version}/beyla-linux-amd64-v${version}.tar.gz";
      hash = "sha256-IzKjlgTXXpYGWlbPSxmKNRONXDmZcYD4em3lOIdGf8o=";
    };
    sourceRoot = ".";
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.stdenv.cc.cc.lib ];
    installPhase = ''
      runHook preInstall
      install -Dm755 beyla $out/bin/beyla
      runHook postInstall
    '';
  };
in mkImage {
  inherit drv;
  name = "grafana-beyla";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/beyla" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "grafana-beyla";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-binary";
  };
}
