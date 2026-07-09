{ mkImage, pkgs, lib, ... }:

# fleet-server - Elastic Fleet Server (central management for Elastic Agents)
# https://www.elastic.co/guide/en/fleet/current/fleet-server.html
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "9.0.3";

  drv = pkgs.buildGoModule {
    pname = "fleet-server";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "elastic";
      repo = "fleet-server";
      rev = "v${version}";
      hash = "sha256-WJAN7T/WQDyC565cuscS4OdtoHuROeifdgLg0NLpKKU=";
    };

    proxyVendor = true;
    vendorHash = "sha256-9/0jPiORyyidwwFCq+19a8niOV/L24QlCkqzT8i5HrI=";

    subPackages = [ "cmd/fleet" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    postInstall = ''
      if [ -e $out/bin/fleet ]; then
        mv $out/bin/fleet $out/bin/fleet-server
      fi
    '';

    meta = with lib; {
      description = "Elastic Fleet Server";
      homepage = "https://github.com/elastic/fleet-server";
      license = licenses.elastic20;
      platforms = [ "x86_64-linux" ];
    };
  };

in mkImage {
  inherit drv;
  name = "fleet-server";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/fleet-server" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "fleet-server";
    "org.opencontainers.image.description" = "Elastic Fleet Server";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
