{ mkImage, pkgs, lib, ... }:

# NATS Server - high-performance messaging system
# https://github.com/nats-io/nats-server
# -fips variant packages the upstream binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "2.14.3";

  drv = pkgs.buildGoModule {
    pname = "nats-server";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "nats-io";
      repo = "nats-server";
      rev = "v${version}";
      hash = "sha256-139eSr6ECC1vThHbdnDPg8wJS0FJuwDKpm4BupRdjSk=";
    };

    proxyVendor = true;
    vendorHash = "sha256-cyPB9faZbj+quu+tq+EBmmoU2qZOsoUQAWFLNICtutM=";

    subPackages = [ "." ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    postInstall = ''
      if [ -e $out/bin/nats-server ]; then
        :
      elif [ -e $out/bin/nats-server_wrap ]; then
        mv $out/bin/nats-server_wrap $out/bin/nats-server
      fi
    '';

    meta = with lib; {
      description = "High-performance messaging server (NATS)";
      homepage = "https://github.com/nats-io/nats-server";
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
    };
  };

in mkImage {
  inherit drv;
  name = "nats-fips";
  tag = "v${version}";
  buildType = "binary";
  entrypoint = [ "${drv}/bin/nats-server" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "nats-fips";
    "org.opencontainers.image.description" = "NATS messaging server";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
