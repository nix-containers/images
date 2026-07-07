{ mkImage, pkgs, lib, ... }:
# image-factory - https://github.com/siderolabs/image-factory
let
  version = "1.3.3";
  drv = pkgs.buildGoModule {
    pname = "image-factory-fips"; inherit version;
    src = pkgs.fetchFromGitHub { owner = "siderolabs"; repo = "image-factory-fips"; rev = "v${version}"; hash = "sha256-sYHFQiRR0avZettJOzXwTdH8wLwIV3Io/w+n/R11+Kc="; };
    vendorHash = "sha256-1PjRJRmOe38epQLK5oVW75EvqBrx01TWl/2REUGmixw=";
    subPackages = [ "cmd/image-factory" ];
    env.CGO_ENABLED = 0; preBuild = "export GOTOOLCHAIN=local"; ldflags = [ "-s" "-w" ]; doCheck = false;
  };
in mkImage { inherit drv; name = "image-factory-fips"; tag = "v${version}"; entrypoint = [ "${drv}/bin/image-factory" ]; cmd = [ "--help" ]; labels = { "org.opencontainers.image.title" = "image-factory-fips"; "org.opencontainers.image.version" = version; "io.nix-containers.source" = "upstream-source"; }; }
