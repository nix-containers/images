{ mkImage, pkgs, lib, ... }:

# Metacontroller - add-on for building Kubernetes controllers
# https://github.com/metacontroller/metacontroller
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "4.16.2";

  drv = pkgs.buildGoModule {
    pname = "metacontroller";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "metacontroller";
      repo = "metacontroller";
      rev = "v${version}";
      hash = "sha256-QXVmGNAvPKS0guHMAZgiEfbRZ116uTeP59NcRKbL04M=";
    };

    proxyVendor = true;
    vendorHash = "sha256-DKD28otjShaN8U63upLQmy8SaLnZbUyG1H9hyd9p2BE=";

    subPackages = [ "pkg/cmd/metacontroller" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    meta = with lib; {
      description = "Add-on for building Kubernetes controllers";
      homepage = "https://github.com/metacontroller/metacontroller";
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
    };
  };

in mkImage {
  inherit drv;
  name = "metacontroller";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/metacontroller" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "metacontroller";
    "org.opencontainers.image.description" = "Add-on for building Kubernetes controllers";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
