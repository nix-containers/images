{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# rancher-fleet-termination-log
# Rancher component

let
  version = "0.15.4";
  rancher-component = buildGoModule {
    pname = "rancher-fleet-termination-log";
    inherit version;

    src = fetchFromGitHub {
      owner = "rancher";
      repo = "fleet";
      rev = "v0.15.4";
      hash = "sha256-wyhLs1vZI8wtIu2rJZYT78GXe9t2VQqhM+MlNlNx6pU=";
    };

    vendorHash = null;
    subPackages = [ "." ];
    
    env.CGO_ENABLED = 0;

    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };

in
mkImage {
  drv = rancher-component;
  name = "rancher-fleet-termination-log";
  tag = "v${version}";
  entrypoint = [ "${rancher-component}/bin/fleet-termination-log" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert tzdata ];

  labels = {
    "org.opencontainers.image.title" = "rancher fleet termination log";
    "org.opencontainers.image.description" = "Rancher rancher-fleet-termination-log";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "rancher";
  };
}
