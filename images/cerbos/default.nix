{ mkImage, pkgs, lib, ... }:

# Cerbos - decoupled access control / authorization server
# https://github.com/cerbos/cerbos

let
  version = "0.53.0";

  # Built from source with current nixpkgs Go so the stdlib CVE from
  # the upstream prebuilt (stdlib v1.26.2 → 1.26.4) clears at each rebuild.
  cerbos = pkgs.buildGoModule {
    pname = "cerbos";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "cerbos";
      repo = "cerbos";
      rev = "v${version}";
      hash = "sha256-Pge4nxR7UMY1a8ytzIWUJZHYBKO5iXvjZJiG8PTG4co=";
    };

    proxyVendor = true;
    vendorHash = "sha256-lGC/c+av1KMSzhV8PDVrckKIjShOACe9f4+DdF6Wkxg=";

    subPackages = [ "cmd/cerbos" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

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
