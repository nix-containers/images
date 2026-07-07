{ mkImage, pkgs, lib, ... }:
# regclient-regbot-fips (regclient) - https://github.com/regclient/regclient
# Built from source + GOTOOLCHAIN=local to clear stale Go-stdlib CVEs.
let
  version = "0.11.5";
  drv = pkgs.buildGoModule {
    pname = "regclient-regbot-fips"; inherit version;
    src = pkgs.fetchFromGitHub { owner = "regclient"; repo = "regclient"; rev = "v${version}"; hash = "sha256-tJBnNtuN9BIlGvHekrvziyBu5gFPzbID/09eAoM5VUc="; };
    vendorHash = "sha256-jpXy3ZWj+JoDKU2r7FanKR8nQGIQPAL9GW4g//e5xZs=";
    subPackages = [ "cmd/regbot" ];
    env.CGO_ENABLED = 0; preBuild = "export GOTOOLCHAIN=local"; ldflags = [ "-s" "-w" ]; doCheck = false;
  };
in mkImage { inherit drv; name = "regclient-regbot-fips"; tag = "v${version}"; entrypoint = [ "${drv}/bin/regbot" ]; cmd = [ "--help" ]; labels = { "org.opencontainers.image.title" = "regclient-regbot-fips"; "org.opencontainers.image.version" = version; "io.nix-containers.source" = "upstream-source"; }; }
