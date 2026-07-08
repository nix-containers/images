{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# rancher-fleet-cli
# Rancher component

let
  version = "0.15.4";
  rancher-component = buildGoModule {
    pname = "rancher-fleet-cli";
    inherit version;

    src = fetchFromGitHub {
      owner = "rancher";
      repo = "fleet";
      rev = "v0.15.4";
      hash = "sha256-wyhLs1vZI8wtIu2rJZYT78GXe9t2VQqhM+MlNlNx6pU=";
    };

    vendorHash = null;
    subPackages = [ "cmd/fleetcli" ];
    
    env.CGO_ENABLED = 0;

    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };

in
mkImage {
  drv = rancher-component;
  name = "rancher-fleet-cli";
  tag = "v${version}";
  entrypoint = [ "${rancher-component}/bin/fleet-cli" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert tzdata ];

  labels = {
    "org.opencontainers.image.title" = "rancher fleet cli";
    "org.opencontainers.image.description" = "Rancher rancher-fleet-cli";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "rancher";
  };
}
