{ nix2container, lib, buildEnv, pkgs, base, nonRoot, ... }:

# postgres-cloudnative-pg
# =============
# PostgreSQL image for CloudNativePG, bundling the pgvector extension.
# https://cloudnative-pg.io/  https://github.com/pgvector/pgvector
#
# Was a bare stub (bash/coreutils only, no postgresql, tag = "latest", no Cmd),
# so the kind-test pod failed with "no command specified". Modeled on the
# merged postgis image (postgres template): the docker-library-compatible
# entrypoint runs initdb on first boot, then execs the server; a first-boot
# initializer enables pgvector in template1 + the default database. In a real
# CloudNativePG cluster the operator's instance manager overrides the command;
# this standalone server is what the kind-test runs and what CNPG wraps.

let
  # PostgreSQL bundled with the pgvector extension so `CREATE EXTENSION vector`
  # finds its control file + .so. Single attr so the server binary on PATH, the
  # image tag, and the org.opencontainers.image.version label all agree.
  postgresql = pkgs.postgresql_16.withPackages (p: [ p.pgvector ]);
  pgvectorVersion = pkgs.postgresql_16.pkgs.pgvector.version;

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

  # docker-library-compatible entrypoint: initdb on first boot, then exec the
  # server. Copied verbatim from the sibling postgres image's
  # docker-entrypoint.sh (pgvector needs no shared_preload_libraries).
  entrypoint = pkgs.writeShellApplication {
    name = "docker-entrypoint.sh";
    runtimeInputs = postgresPackages;
    text = builtins.readFile ./docker-entrypoint.sh;
    excludeShellChecks = [ "SC2086" "SC1090" ];
  };

  # First-boot initializer, sourced by the entrypoint's initdb.d loop, that
  # enables the pgvector extension in template1 + the default database.
  pgvectorInit = pkgs.writeTextDir "docker-entrypoint-initdb.d/10_pgvector.sh"
    (builtins.readFile ./10_pgvector.sh);

  # The uid:gid the server actually runs as (postgres can't run as root).
  postgresUser = { uid = 999; gid = 999; name = "postgres"; home = "/var/lib/postgresql"; };
  userEnv = nonRoot.mkCustomUserEnv pkgs postgresUser [];

  # Pre-create the writable runtime dirs (data + Unix socket dir), owned by the
  # postgres uid so the server can write even when started from a fresh volume.
  pgDirs = pkgs.runCommand "postgres-cloudnative-pg-dirs" {} ''
    mkdir -p $out/var/lib/postgresql/data
    mkdir -p $out/var/run/postgresql
    mkdir -p $out/docker-entrypoint-initdb.d
    chmod 700 $out/var/lib/postgresql/data
    chmod 775 $out/var/run/postgresql
  '';

in
nix2container.buildImage {
  name = "postgres-cloudnative-pg";
  # Version-tag the image (matches the org.opencontainers.image.version label).
  tag = postgresql.version;

  copyToRoot = [
    (buildEnv {
      name = "postgres-cloudnative-pg-root";
      paths = base.basePackages ++ postgresPackages ++ [ entrypoint pgvectorInit userEnv pgDirs ];
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
      "org.opencontainers.image.description" = "PostgreSQL ${postgresql.version} for CloudNativePG with the pgvector ${pgvectorVersion} extension";
      "org.opencontainers.image.url" = "https://github.com/nix-containers/images";
      "org.opencontainers.image.source" = "https://github.com/nix-containers/images";
      "org.opencontainers.image.vendor" = "nix-containers";
      "org.opencontainers.image.version" = postgresql.version;
      "io.nix-containers.image.pgvector-version" = pgvectorVersion;
      "io.nix-containers.image.upstream" = "https://cloudnative-pg.io/";
      "io.nix-containers.image.category" = "database";
      "io.nix-containers.image.aliases" = "postgres-cloudnative-pg,cnpg,postgres,postgresql,pgvector,database";
    };
  };
}
