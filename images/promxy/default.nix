{ mkImage, pkgs, lib, ... }:

# promxy - Prometheus proxy that aggregates multiple Prometheus servers
# https://github.com/jacksontj/promxy

let
  version = "0.0.95";

  drv = pkgs.stdenv.mkDerivation {
    pname = "promxy";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/jacksontj/promxy/releases/download/v${version}/promxy-v${version}-linux-amd64";
      hash = "sha256-cFvJiTU1M/esS04pyp7TiXo1doq0hd7Zbu4cLWN8apY=";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.stdenv.cc.cc.lib ];

    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 $src $out/bin/promxy
      runHook postInstall
    '';
  };

  # The old cmd was `--help` (a one-shot -> the kind-test pod CrashLoops), and
  # promxy refuses to start without a config. Bake a minimal one: a single
  # server group pointing at a localhost Prometheus. The downstream need not be
  # reachable — promxy still starts + serves its API, so the pod stays up.
  # Operators mount their own config with real server_groups.
  promxyConfig = pkgs.writeTextDir "etc/promxy/config.yaml" ''
    promxy:
      server_groups:
        - static_configs:
            - targets: ["localhost:9090"]
  '';
in mkImage {
  inherit drv;
  name = "promxy";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/promxy" ];
  cmd = [ "--config=/etc/promxy/config.yaml" "--bind-addr=0.0.0.0:8082" ];

  extraPkgs = [ promxyConfig ];
  labels = {
    "org.opencontainers.image.title" = "promxy";
    "org.opencontainers.image.description" = "Prometheus proxy aggregating multiple Prometheus servers";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-binary";
  };
}
