{ mkImage, pkgs, lib, ... }:

# tdbg - Temporal debug CLI, shipped in the Temporal server release archive
# https://github.com/temporalio/temporal

let
  version = "1.31.2";

  drv = pkgs.stdenv.mkDerivation {
    pname = "tdbg";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/temporalio/temporal/releases/download/v${version}/temporal_${version}_linux_amd64.tar.gz";
      hash = "sha256-NtMif7vFIkCb0qwlnbWNI/GQ6D9V8a6+hVZBkLNPrhY=";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.stdenv.cc.cc.lib ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      install -Dm755 tdbg $out/bin/tdbg
      runHook postInstall
    '';
  };
in mkImage {
  inherit drv;
  name = "tdbg";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/tdbg" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "tdbg";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-binary";
  };
}
