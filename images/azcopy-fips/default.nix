{ mkImage, pkgs, lib, ... }:

# azcopy - Azure Storage data transfer command-line utility
# https://github.com/Azure/azure-storage-azcopy
let
  version = "10.32.5";

  drv = pkgs.stdenv.mkDerivation {
    pname = "azcopy";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/Azure/azure-storage-azcopy/releases/download/v${version}/azcopy_linux_amd64_${version}.tar.gz";
      hash = "sha256-hvp92zb7SRm+a/sa7BHpgyoG8nh9H9FPJnKIRzE4fGU=";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.stdenv.cc.cc.lib ];

    sourceRoot = "azcopy_linux_amd64_${version}";

    installPhase = ''
      runHook preInstall
      install -Dm755 azcopy $out/bin/azcopy
      runHook postInstall
    '';
  };
in mkImage {
  inherit drv;
  name = "azcopy-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/azcopy" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "azcopy";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-binary";
  };
}
