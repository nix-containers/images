{ mkImage, pkgs, lib, ... }:

# Envoy Gateway - manages Envoy Proxy as a standalone or Kubernetes-based API Gateway
# https://github.com/envoyproxy/gateway
# -fips variant packages the upstream binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "1.8.2";

  drv = pkgs.buildGoModule {
    pname = "envoy-gateway";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "envoyproxy";
      repo = "gateway";
      rev = "v${version}";
      hash = "sha256-givYesuucfw/gumEwxpU/NTtyfZQgmGXg7u+xg9Yx0s=";
    };

    proxyVendor = true;
    vendorHash = "sha256-5Hlycq0+/wvboP81MKlKBFLEgxa545eyXwPtueHONNE=";

    subPackages = [ "cmd/envoy-gateway" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    meta = with lib; {
      description = "Manages Envoy Proxy as a standalone or Kubernetes-based API Gateway";
      homepage = "https://github.com/envoyproxy/gateway";
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
    };
  };

in mkImage {
  inherit drv;
  name = "envoy-gateway-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/envoy-gateway" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "envoy-gateway-fips";
    "org.opencontainers.image.description" = "Envoy Gateway - Kubernetes-based API Gateway";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
