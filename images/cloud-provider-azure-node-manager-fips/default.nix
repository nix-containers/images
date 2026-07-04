{ mkImage, pkgs, lib, ... }:

# Azure cloud node manager - Kubernetes cloud-provider for Azure
# https://github.com/kubernetes-sigs/cloud-provider-azure
# (-fips image variant; packages the upstream binary)
let
  version = "1.36.3";

  drv = pkgs.stdenv.mkDerivation {
    pname = "cloud-provider-azure-node-manager-fips";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/kubernetes-sigs/cloud-provider-azure/releases/download/v${version}/azure-cloud-node-manager-linux-amd64";
      hash = "sha256-vy3Eh/GnMgDibZcuQ/zYxvY6J/GnBGL72jh+p8ogaS8=";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.stdenv.cc.cc.lib ];

    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 $src $out/bin/azure-cloud-node-manager
      runHook postInstall
    '';
  };
in mkImage {
  inherit drv;
  name = "cloud-provider-azure-node-manager-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/azure-cloud-node-manager" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "cloud-provider-azure-node-manager-fips";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-binary";
  };
}
