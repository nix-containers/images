{ mkImage, pkgs, lib, ... }:
# pg_timetable (pg-timetable) - https://github.com/cybertec-postgresql/pg_timetable
# Built from source + GOTOOLCHAIN=local to clear stale Go-stdlib CVEs.
let
  version = "6.3.0";
  drv = pkgs.buildGoModule {
    pname = "pg-timetable"; inherit version;
    src = pkgs.fetchFromGitHub { owner = "cybertec-postgresql"; repo = "pg_timetable"; rev = "v${version}"; hash = "sha256-aIX0uSy9OrMUclsIOn7qFLltOqnHXxha4f+n2lV6xHc="; };
    vendorHash = "sha256-ZpwF2WHSPI8cEs3RLQ4K4f6jXN+XHxQecbloninUYrg=";
    env.CGO_ENABLED = 0; preBuild = "export GOTOOLCHAIN=local"; ldflags = [ "-s" "-w" ]; doCheck = false;
  };
in mkImage { inherit drv; name = "pg-timetable"; tag = "v${version}"; entrypoint = [ "${drv}/bin/pg_timetable" ]; cmd = [ "--help" ]; labels = { "org.opencontainers.image.title" = "pg-timetable"; "org.opencontainers.image.version" = version; "io.nix-containers.source" = "upstream-source"; }; }
