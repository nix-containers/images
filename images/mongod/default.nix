{ mkImage, pkgs, lib, ... }:

# MongoDB server daemon (mongod) - upstream prebuilt Linux x86_64 binary
# https://www.mongodb.com/try/download/community

let
  version = "8.0.26";
  subdir = "mongodb-linux-x86_64-ubuntu2204-${version}";

  drv = pkgs.stdenv.mkDerivation {
    pname = "mongod";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://fastdl.mongodb.org/linux/${subdir}.tgz";
      hash = "sha256-8zkInMowUE4HopP+dmz/ev4Zw3C99NbeWPIWWv/AXUY=";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];

    buildInputs = with pkgs; [
      stdenv.cc.cc.lib
      openssl
      curl
      zlib
    ];

    sourceRoot = subdir;

    installPhase = ''
      runHook preInstall
      install -Dm755 bin/mongod $out/bin/mongod
      runHook postInstall
    '';

    dontStrip = true;

    meta = with lib; {
      description = "MongoDB database server daemon";
      homepage = "https://www.mongodb.com";
      license = licenses.sspl;
      platforms = [ "x86_64-linux" ];
    };
  };

  # The old cmd was `--help` (a one-shot -> the kind-test pod CrashLoops). mongod
  # also refuses to start without an existing --dbpath, so create it at runtime
  # under the writable /tmp mkImage provides, then exec the server bound on all
  # interfaces (0.0.0.0:27017). Operators mount their own volume at /tmp/mongodb
  # (or override the command) for real data.
  entrypoint = pkgs.writeShellApplication {
    name = "docker-entrypoint.sh";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      mkdir -p /tmp/mongodb
      exec ${drv}/bin/mongod --dbpath /tmp/mongodb --bind_ip_all "$@"
    '';
  };

in mkImage {
  inherit drv;
  name = "mongod";
  tag = "v${version}";
  entrypoint = [ "${entrypoint}/bin/docker-entrypoint.sh" ];
  cmd = [ ];

  labels = {
    "org.opencontainers.image.title" = "mongod";
    "org.opencontainers.image.description" = "MongoDB database server daemon";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-binary";
  };
}
