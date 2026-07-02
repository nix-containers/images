{ mkImage, pkgs, lib, ... }:

# ChartMuseum - Helm Chart Repository server
# https://github.com/helm/chartmuseum

let
  version = "0.16.5";

  chartmuseum = pkgs.stdenv.mkDerivation rec {
    pname = "chartmuseum";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://get.helm.sh/chartmuseum-v${version}-linux-amd64.tar.gz";
      hash = "sha256-aH1qDa83K+6L1Titd9adAHgl/H6rit6LguQB+Exuwa4=";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];

    buildInputs = with pkgs; [
      stdenv.cc.cc.lib
      zlib
    ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp linux-amd64/chartmuseum $out/bin/chartmuseum
      chmod +x $out/bin/chartmuseum
      runHook postInstall
    '';

    meta = with lib; {
      description = "Helm Chart Repository server";
      homepage = "https://github.com/helm/chartmuseum";
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
    };
  };

  # The old cmd was `--help` (a one-shot -> the kind-test pod CrashLoops). Run
  # the server with the local filesystem storage backend under the writable
  # /tmp mkImage provides (created at runtime), bound on 0.0.0.0:8080. Operators
  # mount their own storage / config (S3/GCS/…) or override the command.
  entrypoint = pkgs.writeShellApplication {
    name = "docker-entrypoint.sh";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      mkdir -p /tmp/charts
      exec ${chartmuseum}/bin/chartmuseum \
        --storage local \
        --storage-local-rootdir /tmp/charts \
        --port 8080 "$@"
    '';
  };

in mkImage {
  drv = chartmuseum;
  name = "chartmuseum";
  tag = "v${version}";
  entrypoint = [ "${entrypoint}/bin/docker-entrypoint.sh" ];
  cmd = [ ];

  labels = {
    "org.opencontainers.image.title" = "chartmuseum";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-binary";
  };
}