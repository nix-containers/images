{ mkImage, pkgs, lib, ... }:

# argo-events (fips variant) - https://github.com/argoproj/argo-events
# Built from source + GOTOOLCHAIN=local to clear stale Go-stdlib CVEs.
let
  version = "1.9.10";
  drv = pkgs.buildGoModule {
    pname = "argo-events-fips";
    inherit version;
    src = pkgs.fetchFromGitHub {
      owner = "argoproj"; repo = "argo-events";
      rev = "v${version}"; hash = "sha256-C0FDilzSjY7OMtqQV/mudT+Ojg4+w2FL6IKVgs0dNQ4=";
    };
    vendorHash = "sha256-XeA2SwqS8qZVWisXhGAGE+kFH/tyRdb29L+3sPfLIZU=";
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
