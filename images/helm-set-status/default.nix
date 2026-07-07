{ mkImage, pkgs, lib, ... }:

# helm-set-status - https://github.com/josegonzalez/helm-set-status
# Built from source + GOTOOLCHAIN=local to clear stale Go-stdlib CVEs.
let
  version = "0.2.0";
  drv = pkgs.buildGoModule {
    pname = "helm-set-status";
    inherit version;
    src = pkgs.fetchFromGitHub {
      owner = "josegonzalez"; repo = "helm-set-status";
      rev = "v${version}"; hash = "sha256-waUMgQQl/A9v9q9tGI00cI/neQVehKjhS3bGQ/IV/b0=";
    };
    vendorHash = "sha256-VjVv1J9pbsun3/2MDVehVTA3cQCoprDWleReqAAK/Xs=";
    env.CGO_ENABLED = 0;
    preBuild = "export GOTOOLCHAIN=local";
    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };
in mkImage {
  inherit drv; name = "helm-set-status"; tag = "v${version}";
  entrypoint = [ "${drv}/bin/helm-set-status" ]; cmd = [ "--help" ];
  labels = { "org.opencontainers.image.title" = "helm-set-status"; "org.opencontainers.image.version" = version; "io.nix-containers.source" = "upstream-source"; };
}
