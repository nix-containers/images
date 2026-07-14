{ mkImage, pkgs, lib, ... }:

# log-counter - log pattern counter shipped with node-problem-detector
# https://github.com/kubernetes/node-problem-detector
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "1.36.0";

  drv = pkgs.buildGoModule {
    pname = "log-counter";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "kubernetes";
      repo = "node-problem-detector";
      rev = "v${version}";
      hash = "sha256-hDf6F9sCrX6vu9FJlXTMRtGaA+gwI7PdqD9GKINHPO0=";
    };

    vendorHash = null;

    subPackages = [ "cmd/logcounter" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    postInstall = ''
      if [ -e $out/bin/logcounter ]; then
        mv $out/bin/logcounter $out/bin/log-counter
      fi
    '';
  };
in mkImage {
  inherit drv;
  name = "log-counter";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/log-counter" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "log-counter";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
