{ mkImage, pkgs, lib, ... }:
# nats-box (natscli) - https://github.com/nats-io/natscli
let
  version = "0.4.0";
  drv = pkgs.buildGoModule {
    pname = "nats-box-fips"; inherit version;
    src = pkgs.fetchFromGitHub { owner = "nats-io"; repo = "natscli"; rev = "v${version}"; hash = "sha256-NF2A4bkGczaH+TYwQnLSvt21uQIk5FZomQuVl22CP30="; };
    vendorHash = "sha256-mRsHVNs+kyiXP35YQMO9bxWK0sf51hRR7Pcn5oQKl6c=";
    subPackages = [ "nats" ];
    env.CGO_ENABLED = 0; preBuild = "export GOTOOLCHAIN=local"; ldflags = [ "-s" "-w" ]; doCheck = false;
  };
in mkImage { inherit drv; name = "nats-box-fips"; tag = "v${version}"; entrypoint = [ "${drv}/bin/nats" ]; cmd = [ "--help" ]; labels = { "org.opencontainers.image.title" = "nats-box-fips"; "org.opencontainers.image.version" = version; "io.nix-containers.source" = "upstream-source"; }; }
