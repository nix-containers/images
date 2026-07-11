{ mkImage, pkgs, lib, ... }:

# Grafana Beyla - eBPF-based application auto-instrumentation tool
# https://github.com/grafana/beyla
let
  version = "3.27.0";
  drv = pkgs.stdenv.mkDerivation {
    pname = "grafana-beyla";
    inherit version;
    src = pkgs.fetchurl {
      url = "https://github.com/grafana/beyla/releases/download/v${version}/beyla-linux-amd64-v${version}.tar.gz";
      hash = "sha256-0RAmDX2/IG8xz61Fbz0c8bqdLd/Tll2BXDCJ1DI6Xj4=";
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
