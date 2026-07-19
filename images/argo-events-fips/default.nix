{ mkImage, pkgs, lib, ... }:

# argo-events (fips variant) - https://github.com/argoproj/argo-events
# Built from source + GOTOOLCHAIN=local to clear stale Go-stdlib CVEs.
let
  version = "1.9.11";
  drv = pkgs.buildGoModule {
    pname = "argo-events-fips";
    inherit version;
    src = pkgs.fetchFromGitHub {
      owner = "argoproj"; repo = "argo-events";
      rev = "v${version}"; hash = "sha256-nj/5h5oQEKXbWJLeCzVD0CGQT9vpr/YNgN0nboarFqU=";
    };
    vendorHash = "sha256-ElF11vh24MeGs5xcFVkFxiBc3eahg3np+XT9GMwhgpw=";
    env.CGO_ENABLED = 0;
    preBuild = "export GOTOOLCHAIN=local";
    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };
in mkImage {
  inherit drv; name = "argo-events-fips"; tag = "v${version}";
  entrypoint = [ "${drv}/bin/argo-events" ]; cmd = [ "--help" ];
  labels = { "org.opencontainers.image.title" = "argo-events-fips"; "org.opencontainers.image.version" = version; "io.nix-containers.source" = "upstream-source"; };
}
