{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# cert-manager-csi-driver
# cert-manager component

let
  version = "1.21.0";
  component = buildGoModule {
    pname = "cert-manager-csi-driver";
    inherit version;
    src = fetchFromGitHub {
      owner = "cert-manager";
      repo = "cert-manager";
      rev = "v${version}";
      hash = "sha256-yUO2nloWL+OdRv9dyq5q7Zxr+a4L4ljYD5R4w9bhbhU=";
    };
    vendorHash = "sha256-Gb6RIW+pmrY4bLzWx3E+s9I0w0f6o2LWKZQyrX/2tFQ=";
    subPackages = [ "." ];
    env.CGO_ENABLED = 0;
    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };

in mkImage {
  drv = component;
  name = "cert-manager-csi-driver";
  tag = "v${version}";
  entrypoint = [ "${component}/bin/cert-manager-csi-driver" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.title" = "cert-manager-csi-driver";
    "org.opencontainers.image.description" = "cert-manager cert-manager-csi-driver";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "cert-manager";
  };
}