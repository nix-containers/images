{ mkImage, pkgs, lib, ... }:

# Cerbos - decoupled access control / authorization server
# https://github.com/cerbos/cerbos

let
  version = "0.53.0";

  cerbos = pkgs.stdenv.mkDerivation rec {
    pname = "cerbos";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/cerbos/cerbos/releases/download/v${version}/cerbos_${version}_Linux_x86_64.tar.gz";
      hash = "sha256-VkJxdr0uXmdgl/mgh0PtIR58ASOvHnGkj5TUl+PJ4TE=";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];

    buildInputs = with pkgs; [
      stdenv.cc.cc.lib
    ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp cerbos $out/bin/cerbos
      chmod +x $out/bin/cerbos
      runHook postInstall
    '';

    meta = with lib; {
      description = "Decoupled access control / authorization server";
      homepage = "https://github.com/cerbos/cerbos";
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
    };
  };

  # Cerbos needs a config; without one the old cmd was `--help` (a one-shot ->
  # the kind-test pod CrashLoops). Bake a minimal config: HTTP :3592 + gRPC :3593
  # on 0.0.0.0, disk policy store under the writable /tmp mkImage provides.
  # Operators mount their own policies at /tmp/cerbos-policies + config.
  cerbosConfig = pkgs.writeTextDir "etc/cerbos/config.yaml" ''
    server:
      httpListenAddr: "0.0.0.0:3592"
      grpcListenAddr: "0.0.0.0:3593"
    storage:
      driver: "disk"
      disk:
        directory: /tmp/cerbos-policies
        watchForChanges: false
  '';

  entrypoint = pkgs.writeShellApplication {
    name = "docker-entrypoint.sh";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      mkdir -p /tmp/cerbos-policies
      exec ${cerbos}/bin/cerbos server --config=/etc/cerbos/config.yaml "$@"
    '';
  };

in mkImage {
  drv = cerbos;
  name = "cerbos";
  tag = "v${version}";
  entrypoint = [ "${entrypoint}/bin/docker-entrypoint.sh" ];
  cmd = [ ];

  extraPkgs = [ cerbosConfig ];

  labels = {
    "org.opencontainers.image.title" = "cerbos";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-binary";
  };
}
