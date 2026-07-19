{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# calico-apiserver-fips
# Calico networking component

let
  version = "3.32.1";
  calico-component = buildGoModule {
    pname = "calico-apiserver-fips";
    inherit version;
    src = fetchFromGitHub {
      owner = "projectcalico";
      repo = "calico";
      rev = "v${version}";
      hash = "sha256-bgcY/unCLAtPOeEwRJGl8u1dHYdO3tSzMTg47DHOsJM=";
    };
    vendorHash = "sha256-9Kap6qHIttgMRSnSnTUvWj72jp5u2vIMy5l2sJRfKlU=";
    subPackages = [ "." ];
    env.CGO_ENABLED = 1;
    env.GOEXPERIMENT = "boringcrypto";
    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };

in mkImage {
  drv = calico-component;
  name = "calico-apiserver-fips";
  tag = "v${version}";
  entrypoint = [ "${calico-component}/bin/apiserver" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert iptables ];
  labels = {
    "org.opencontainers.image.title" = "calico apiserver";
    "org.opencontainers.image.description" = "Calico calico-apiserver";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "calico";
    "io.nix-containers.compliance" = "FIPS-140-2";
  };
}
