{ nix2container, lib, buildEnv, pkgs, base, nonRoot, ... }:

# timestamp-authority
# =============
# sigstore timestamp-authority — an RFC 3161 timestamping server.
# https://github.com/sigstore/timestamp-authority
#
# Was a bare stub (bash/coreutils only, tag = "latest", no Entrypoint/Cmd), so
# the kind-test pod failed with "no command specified". Package the upstream
# statically-linked linux/amd64 `timestamp-server` release binary and run it
# with the in-memory signer bound on 0.0.0.0.

let
  version = "2.1.2";

  # Upstream ships a fully static (CGO-free) Go binary, so no autoPatchelf or
  # runtime libraries are needed — just install it onto PATH.
  drv = pkgs.stdenv.mkDerivation {
    pname = "timestamp-server";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/sigstore/timestamp-authority/releases/download/v${version}/timestamp-server-linux-amd64";
      hash = "sha256-SOzgMNX8nzR5rzoea1QPBS0kMCk48+DrIEN3yEUqLUU=";
    };

    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 $src $out/bin/timestamp-server
      runHook postInstall
    '';
  };

  imagePkgs = with pkgs; [
    bash
    coreutils
    cacert
    tzdata
  ];

  userEnv = nonRoot.mkDefaultUserEnv pkgs [];

in nix2container.buildImage {
  name = "timestamp-authority";
  # Version-tag the image (matches the org.opencontainers.image.version label).
  tag = "v${version}";
  copyToRoot = [
    (buildEnv {
      name = "timestamp-authority-root";
      paths = base.basePackages ++ imagePkgs ++ [ drv userEnv ];
    })
  ];
  config = nonRoot.defaultConfig // {
    Entrypoint = [ "${drv}/bin/timestamp-server" ];
    # Serve the RFC 3161 API on 0.0.0.0:3000 with the in-memory signer (an
    # ephemeral key — no external KMS/file dependency, so the pod comes up
    # unattended). NTP monitoring is disabled because an isolated pod has no
    # outbound NTP. Operators override with kms/tink/file signers + certs.
    Cmd = [
      "serve"
      "--host" "0.0.0.0"
      "--port" "3000"
      "--timestamp-signer" "memory"
      "--disable-ntp-monitoring"
    ];
    Env = base.defaultEnv ++ nonRoot.userEnv;
    ExposedPorts = {
      "3000/tcp" = {};
    };
    Labels = base.defaultLabels // {
      "io.nix-containers.build-type" = "source";
      "io.nix-containers.build-method" = "Built from source using Nix";
      "org.opencontainers.image.title" = "timestamp-authority";
      "org.opencontainers.image.description" = "sigstore timestamp-authority — RFC 3161 timestamping server";
      "org.opencontainers.image.url" = "https://github.com/nix-containers/images";
      "org.opencontainers.image.source" = "https://github.com/nix-containers/images";
      "org.opencontainers.image.vendor" = "nix-containers";
      "org.opencontainers.image.version" = version;
      "io.nix-containers.image.upstream" = "https://github.com/sigstore/timestamp-authority";
      "io.nix-containers.image.category" = "security";
      "io.nix-containers.image.aliases" = "timestamp-authority,tsa,timestamp-server,sigstore";
    };
  };
}
