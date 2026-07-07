{ mkImage, pkgs, lib, ... }:
# pg_timetable (pg_timetable-fips) - https://github.com/cybertec-postgresql/pg_timetable
# Built from source + GOTOOLCHAIN=local to clear stale Go-stdlib CVEs.
let
  version = "6.3.0";
  drv = pkgs.buildGoModule {
    pname = "pg_timetable-fips"; inherit version;
    src = pkgs.fetchFromGitHub { owner = "cybertec-postgresql"; repo = "pg_timetable"; rev = "v${version}"; hash = "sha256-aIX0uSy9OrMUclsIOn7qFLltOqnHXxha4f+n2lV6xHc="; };
    vendorHash = "sha256-ZpwF2WHSPI8cEs3RLQ4K4f6jXN+XHxQecbloninUYrg=";
    env.CGO_ENABLED = 0; preBuild = "export GOTOOLCHAIN=local"; ldflags = [ "-s" "-w" ]; doCheck = false;
  };
in mkImage { inherit drv; name = "pg_timetable-fips"; tag = "v${version}"; entrypoint = [ "${drv}/bin/pg_timetable" ]; cmd = [ "--help" ]; labels = { "org.opencontainers.image.title" = "pg_timetable-fips"; "org.opencontainers.image.version" = version; "io.nix-containers.source" = "upstream-source"; }; }
