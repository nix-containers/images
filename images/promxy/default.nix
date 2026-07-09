{ mkImage, pkgs, lib, ... }:

# promxy - Prometheus proxy that aggregates multiple Prometheus servers
# https://github.com/jacksontj/promxy
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "0.0.96";

  drv = pkgs.buildGoModule {
    pname = "promxy";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "jacksontj";
      repo = "promxy";
      rev = "v${version}";
      hash = "sha256-qj9Sd4TdTD94VWnNB8/kIvHm+mYhfoRCqdsNeRNpoV0=";
    };

    vendorHash = null;

    subPackages = [ "cmd/promxy" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
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
    "io.nix-containers.source" = "upstream-source";
  };
}
