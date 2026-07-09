{ mkImage, pkgs, lib, ... }:

# Temporal Server - durable execution platform server binary
# https://github.com/temporalio/temporal
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt release clear at each rebuild.
let
  version = "1.31.2";
  drv = pkgs.buildGoModule {
    pname = "temporal-server";
    inherit version;
    src = pkgs.fetchFromGitHub {
      owner = "temporalio";
      repo = "temporal";
      rev = "v${version}";
      hash = "sha256-NuvgeG1a7octJ2HD0EGQIdU8CtZsNRf4KX/F17S/uOQ=";
    };
    proxyVendor = true;
    vendorHash = "sha256-yDhdEFZrMpddw96Q1z2oQbQLtV56orliM9F13euI/m8=";

    subPackages = [ "cmd/server" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    # Rename output binary to temporal-server, and copy the source-tree config
    # directory so the entrypoint's --root/--env pointer keeps working.
    postInstall = ''
      if [ -e $out/bin/server ]; then
        mv $out/bin/server $out/bin/temporal-server
      fi
      cp -r config $out/config
    '';
  };

  # Derive a runnable config from the upstream `development-sqlite` env
  # (in-memory SQLite -> no external DB, no schema setup) with the services
  # bound on all interfaces instead of localhost, plus its dynamic-config file
  # (referenced by a CWD-relative path). sed keeps this in sync with upstream.
  serverConfig = pkgs.runCommand "temporal-server-config" {} ''
    mkdir -p $out/config/dynamicconfig
    sed 's/      bindOnLocalHost: true/      bindOnLocalHost: false\n      bindOnIP: "0.0.0.0"/' \
      ${drv}/config/development-sqlite.yaml > $out/config/development-sqlite.yaml
    cp ${drv}/config/dynamicconfig/development-sql.yaml $out/config/dynamicconfig/
  '';

  # Was cmd=["--help"] (a one-shot -> the kind-test pod CrashLoops). Run the
  # all-in-one server (frontend/history/matching/worker) on the in-memory SQLite
  # config, frontend gRPC on 0.0.0.0:7233. temporal resolves the dynamic-config
  # filepath relative to CWD, so cd into the config root first. Operators mount
  # their own config (real datastore) + point --root at it.
  entrypoint = pkgs.writeShellApplication {
    name = "docker-entrypoint.sh";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      cd ${serverConfig}
      exec ${drv}/bin/temporal-server --env development-sqlite --root ${serverConfig} start "$@"
    '';
  };
in mkImage {
  inherit drv;
  name = "temporal-server";
  tag = "v${version}";
  entrypoint = [ "${entrypoint}/bin/docker-entrypoint.sh" ];
  cmd = [ ];
  labels = {
    "org.opencontainers.image.title" = "temporal-server";
    "org.opencontainers.image.description" = "Temporal durable execution platform server";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
