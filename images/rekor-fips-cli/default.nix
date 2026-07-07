{ mkImage, pkgs, lib, ... }:

# rekor-cli (fips variant) - https://github.com/sigstore/rekor
# Built from source + GOTOOLCHAIN=local to clear stale Go-stdlib CVEs.
let
  version = "1.5.2";
  drv = pkgs.buildGoModule {
    pname = "rekor-fips-cli"; inherit version;
    src = pkgs.fetchFromGitHub {
      owner = "sigstore"; repo = "rekor";
      rev = "v${version}"; hash = "sha256-fqhEjVrEOejbUco80rRQsNDK9URZ3Ob2Eo6xBHt4tVM=";
    };
    vendorHash = "sha256-QxIw3rGTntNpLNhLZq9G6OiuTd+UbjA5B60TYBqFiSY=";
    subPackages = [ "cmd/rekor-cli" ];
    env.CGO_ENABLED = 0;
    preBuild = "export GOTOOLCHAIN=local";
    ldflags = [ "-s" "-w" ]; doCheck = false;
  };
in mkImage {
  inherit drv; name = "rekor-fips-cli"; tag = "v${version}";
  entrypoint = [ "${drv}/bin/rekor-cli" ]; cmd = [ "--help" ];
  labels = { "org.opencontainers.image.title" = "rekor-fips-cli"; "org.opencontainers.image.version" = version; "io.nix-containers.source" = "upstream-source"; };
}
