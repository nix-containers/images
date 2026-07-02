{ nix2container, lib, buildEnv, pkgs, base, nonRoot, ... }:

# timescaledb-compat
# =============
# PostgreSQL with the TimescaleDB time-series extension.
# https://www.timescale.com/
#
# Was a bare stub (bash/coreutils only, no postgresql, tag = "latest", no Cmd),
# so the kind-test pod failed with "no command specified". Modeled on the
# sibling postgres image: the docker-library-compatible entrypoint runs initdb
# on first boot, then execs the server. TimescaleDB additionally requires
# shared_preload_libraries=timescaledb before the extension can be created, so
# the entrypoint persists that to postgresql.conf and a first-boot initializer
# enables the extension in template1 + the default database.

let
  # PostgreSQL bundled with the TimescaleDB extension so `CREATE EXTENSION
  # timescaledb` finds its control file + .so. Single attr so the server binary
  # on PATH, the image tag, and the org.opencontainers.image.version label all
  # agree.
  postgresql = pkgs.postgresql_16.withPackages (p: [ p.timescaledb ]);
  timescaledbVersion = pkgs.postgresql_16.pkgs.timescaledb.version;

  postgresPackages = [
    postgresql
    pkgs.bash
    pkgs.coreutils
    pkgs.findutils
    pkgs.which
    pkgs.gnused
    pkgs.gzip
    pkgs.gosu  # drop root -> postgres uid (initdb/postgres refuse to run as root)
  ];

  # docker-library-compatible entrypoint: initdb on first boot (preloading
  # timescaledb), then exec the server. Copied from the sibling postgres image's
  # docker-entrypoint.sh with the shared_preload_libraries addition.
  entrypoint = pkgs.writeShellApplication {
    name = "docker-entrypoint.sh";
    runtimeInputs = postgresPackages;
    text = builtins.readFile ./docker-entrypoint.sh;
    excludeShellChecks = [ "SC2086" "SC1090" ];
  };

  # First-boot initializer, sourced by the entrypoint's initdb.d loop, that
  # enables the TimescaleDB extension in template1 + the default database.
  timescaledbInit = pkgs.writeTextDir "docker-entrypoint-initdb.d/10_timescaledb.sh"
    (builtins.readFile ./10_timescaledb.sh);

  # The uid:gid the server actually runs as (postgres can't run as root).
  postgresUser = { uid = 999; gid = 999; name = "postgres"; home = "/var/lib/postgresql"; };
  userEnv = nonRoot.mkCustomUserEnv pkgs postgresUser [];

  # Pre-create the writable runtime dirs (data + Unix socket dir), owned by the
  # postgres uid so the server can write even when started from a fresh volume.
  pgDirs = pkgs.runCommand "timescaledb-compat-dirs" {} ''
    mkdir -p $out/var/lib/postgresql/data
    mkdir -p $out/var/run/postgresql
    mkdir -p $out/docker-entrypoint-initdb.d
    chmod 700 $out/var/lib/postgresql/data
    chmod 775 $out/var/run/postgresql
  '';

in
nix2container.buildImage {
  name = "timescaledb-compat";
  # Version-tag the image (matches the org.opencontainers.image.version label).
  tag = postgresql.version;

  copyToRoot = [
    (buildEnv {
      name = "timescaledb-compat-root";
      paths = base.basePackages ++ postgresPackages ++ [ entrypoint timescaledbInit userEnv pgDirs ];
    })
  ];

  perms = [
    {
      path = pgDirs;
      regex = "/var/lib/postgresql/data";
      mode = "0700";
      uid = postgresUser.uid;
      gid = postgresUser.gid;
    }
    {
      path = pgDirs;
      regex = "/var/run/postgresql";
      mode = "0775";
      uid = postgresUser.uid;
      gid = postgresUser.gid;
    }
  ];

  # Chainguard runs postgres as root; the entrypoint drops to the postgres uid
  # (via gosu) before initdb/postgres, which refuse to run as root.
  config = nonRoot.rootConfig // {
    Entrypoint = [ "${entrypoint}/bin/docker-entrypoint.sh" ];
    Cmd = [ "postgres" ];
    Env = base.defaultEnv ++ nonRoot.rootEnv ++ [
      "PATH=${lib.makeBinPath postgresPackages}"
      "PGDATA=/var/lib/postgresql/data"
      "PGHOST=/var/run/postgresql"
      "POSTGRES_DB=postgres"
      "POSTGRES_USER=postgres"
    ];
    ExposedPorts = {
      "5432/tcp" = {};
    };
    Labels = base.defaultLabels // {
      "io.nix-containers.build-type" = "source";
      "io.nix-containers.build-method" = "Built from source using Nix";
      "org.opencontainers.image.description" = "PostgreSQL ${postgresql.version} with the TimescaleDB ${timescaledbVersion} time-series extension";
      "org.opencontainers.image.url" = "https://github.com/nix-containers/images";
      "org.opencontainers.image.source" = "https://github.com/nix-containers/images";
      "org.opencontainers.image.vendor" = "nix-containers";
      "org.opencontainers.image.version" = postgresql.version;
      "io.nix-containers.image.timescaledb-version" = timescaledbVersion;
      "io.nix-containers.image.upstream" = "https://www.timescale.com/";
      "io.nix-containers.image.category" = "database";
      "io.nix-containers.image.aliases" = "timescaledb,timescale,postgres,postgresql,timeseries,database";
    };
  };
}
