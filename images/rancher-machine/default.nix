{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# rancher-machine
# https://github.com/rancher/machine
#
# The scaffold pinned to v2.10.0 which doesn't exist upstream. Real latest
# is a rancher-suffixed variant of the 0.15 line. The binary from `cmd/`
# ships as `rancher-machine`.

let
  version = "0.15.0-rancher137.2";
  rancher-component = buildGoModule {
    pname = "rancher-machine";
    inherit version;

    src = fetchFromGitHub {
      owner = "rancher";
      repo = "machine";
      rev = "v${version}";
      hash = "sha256-QEGRHx7Vsb42vw1GaUQad/wXD+ia/CNI2IQsBIYhioU=";
    };

    proxyVendor = true;
    vendorHash = "sha256-z4pH/KQ5usY4nCy1VhAD7e0ovpvS7QsBb5WfLBeUjls=";

    subPackages = [ "cmd/rancher-machine" ];

    env.CGO_ENABLED = 0;

    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };

in
mkImage {
  drv = rancher-component;
  name = "rancher-machine";
  tag = "v${version}";
  entrypoint = [ "${rancher-component}/bin/rancher-machine" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert tzdata ];

  labels = {
    "org.opencontainers.image.title" = "rancher machine";
    "org.opencontainers.image.description" = "Rancher rancher-machine";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "rancher";
  };
}
