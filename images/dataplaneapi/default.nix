{ mkImage, pkgs, lib, ... }:

# HAProxy Data Plane API - REST API for dynamic HAProxy configuration
# https://github.com/haproxytech/dataplaneapi
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "3.4.0";

  drv = pkgs.buildGoModule {
    pname = "dataplaneapi";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "haproxytech";
      repo = "dataplaneapi";
      rev = "v${version}";
      hash = "sha256-I7f2GFEvGD+cqSxWtTn9MAtR9rhoHRZQi5jvDl34byY=";
    };

    proxyVendor = true;
    vendorHash = "sha256-07t0Clg2bG7j7dwyOFNMMqEjzF20ZcxQSrTSsKo2jps=";

    subPackages = [ "cmd/dataplaneapi" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "dataplaneapi";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/dataplaneapi" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "dataplaneapi";
    "org.opencontainers.image.description" = "HAProxy Data Plane API";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
