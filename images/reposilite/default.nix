{ mkImage, pkgs, lib, ... }:

# reposilite
# =============
# Reposilite - a lightweight Maven/Gradle artifact repository.
# https://reposilite.com/
#
# Was cmd=["--help"] (a one-shot -> the kind-test pod CrashLoops). Run the
# server with a writable working directory, bound on 0.0.0.0:8080.

let
  reposilite = pkgs.reposilite;

  # Reposilite writes its config + embedded SQLite + repositories under the
  # working directory; the image root is a read-only nix store, so point it at
  # the writable /tmp mkImage provides (created at runtime) and bind 0.0.0.0:8080.
  entrypoint = pkgs.writeShellApplication {
    name = "docker-entrypoint.sh";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      mkdir -p /tmp/reposilite
      exec ${lib.getExe reposilite} --working-directory=/tmp/reposilite --port=8080 "$@"
    '';
  };
in
mkImage {
  drv = reposilite;
  name = "reposilite";
  tag = "v${reposilite.version}";
  entrypoint = [ "${entrypoint}/bin/docker-entrypoint.sh" ];
  cmd = [ ];

  labels = {
    "org.opencontainers.image.title" = "reposilite";
    "org.opencontainers.image.description" = "Reposilite - lightweight Maven/Gradle artifact repository";
    "org.opencontainers.image.version" = reposilite.version;
    "io.nix-containers.source" = "nixpkgs";
  };
}
