{ mkImage, pkgs, lib, ... }:

# Istio Envoy - the Envoy proxy build used by Istio's data plane.
# Prebuilt binary published to the istio-build GCS bucket, keyed by the
# proxy SHA pinned in istio/istio's istio.deps for the release.
# https://github.com/istio/proxy

#
# ALIGNED TO WHAT IS ACTUALLY DEPLOYED. This previously pinned the proxy SHA
# from istio 1.30.2 while every cluster runs
# registry.istio.io/release/proxyv2:1.30.4, so the packaged Envoy was two patch
# releases behind the one in production and the image could not be used as a
# drop-in for it. The SHA below is PROXY_REPO_SHA from istio/istio's istio.deps
# at tag 1.30.4, which is the authoritative pin for that release.

let
  version = "1.30.4";
  proxySha = "ce177c56fe75661f16b654e2f164d4ab02058222";

  drv = pkgs.stdenv.mkDerivation {
    pname = "istio-envoy";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://storage.googleapis.com/istio-build/proxy/envoy-alpha-${proxySha}.tar.gz";
      hash = "sha256-/tbAdsthLw0Nn/JcYtVYeqnWBMfYAFRFTQWhV7U98+s=";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];

    buildInputs = with pkgs; [
      stdenv.cc.cc.lib
      zlib
    ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      install -Dm755 usr/local/bin/envoy $out/bin/envoy
      runHook postInstall
    '';

    dontStrip = true;
  };

in mkImage {
  inherit drv;
  name = "istio-envoy";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/envoy" ];
  cmd = [ "--version" ];

  labels = {
    "org.opencontainers.image.title" = "istio-envoy";
    "org.opencontainers.image.description" = "Envoy proxy build used by Istio";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-binary";
  };
}
