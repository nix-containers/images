{ mkImage, pkgs, lib, ... }:

# CNI loopback plugin (from containernetworking/plugins)
# -fips suffix denotes the same upstream tool; no FIPS claim.
# https://github.com/containernetworking/plugins
#
# Rebuilt from source with current nixpkgs Go so stdlib CVEs clear at each rebuild.
let
  version = "1.9.1";
  binary = "loopback";

  drv = pkgs.buildGoModule {
    pname = "cni-plugins-fips-${binary}";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "containernetworking";
      repo = "plugins";
      rev = "v${version}";
      hash = "sha256-3OhUvIJPU5Ayc4/po9Rj4Tfa5536aN8bj+51M6Xg5os=";
    };

    vendorHash = null;

    subPackages = [ "plugins/main/${binary}" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "cni-plugins-fips-loopback";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/${binary}" ];
  cmd = [ ];

  labels = {
    "org.opencontainers.image.title" = "cni-plugins-fips-loopback";
    "org.opencontainers.image.description" = "CNI loopback plugin";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
