{ mkImage, pkgs, lib, ... }:

# InfluxDB CLI (influx) - https://github.com/influxdata/influx-cli
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "2.8.0";

  drv = pkgs.buildGoModule {
    pname = "influx";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "influxdata";
      repo = "influx-cli";
      rev = "v${version}";
      hash = "sha256-3DCvWaiGLw9OSs/b9za1jgrPDo2Txw5b5h46ElTMEks=";
    };

    proxyVendor = true;
    vendorHash = "sha256-jFZ3Cwt6SoV1juBe2Jfj6wzNAEvM+a87rhoFBh6rKWo=";

    subPackages = [ "cmd/influx" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "influx";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/influx" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "influx";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
