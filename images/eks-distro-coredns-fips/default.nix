{ mkImage, pkgs, lib, ... }:
# coredns (eks-distro) - https://github.com/coredns/coredns
let
  version = "1.14.4";
  drv = pkgs.buildGoModule {
    pname = "eks-distro-coredns-fips"; inherit version;
    src = pkgs.fetchFromGitHub { owner = "coredns"; repo = "coredns"; rev = "v${version}"; hash = "sha256-ByfXuFjALQV7iDb+QVGaP1UYDPXZTHAiTdcxNLbETCs="; };
    vendorHash = "sha256-I+lO6HMtKX8N79Bdm8AzzIZe8mMYjHklZ85HjAjL1lk=";
    env.CGO_ENABLED = 0; preBuild = "export GOTOOLCHAIN=local"; ldflags = [ "-s" "-w" ]; doCheck = false;
  };
in mkImage { inherit drv; name = "eks-distro-coredns-fips"; tag = "v${version}"; entrypoint = [ "${drv}/bin/coredns" ]; cmd = [ "--help" ]; labels = { "org.opencontainers.image.title" = "eks-distro-coredns-fips"; "org.opencontainers.image.version" = version; "io.nix-containers.source" = "upstream-source"; }; }
