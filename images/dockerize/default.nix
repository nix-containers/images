{ mkImage, pkgs, lib, ... }:

# dockerize - utility to simplify running apps in containers
# https://github.com/jwilder/dockerize
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "0.13.0";

  drv = pkgs.buildGoModule {
    pname = "dockerize";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "jwilder";
      repo = "dockerize";
      rev = "v${version}";
      hash = "sha256-f/9nE5qKL6g/hHRYLS8kwCWF9ULWlyAWGxx7e/mxTcw=";
    };

    proxyVendor = true;
    vendorHash = "sha256-ehelUqhUoJS5GsZi4pIY3BP/Za02UrdKkomzNDv8FJw=";

    subPackages = [ "." ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    meta = with lib; {
      description = "Utility to simplify running applications in Docker containers";
      homepage = "https://github.com/jwilder/dockerize";
      license = licenses.mit;
      platforms = [ "x86_64-linux" ];
    };
  };
in mkImage {
  inherit drv;
  name = "dockerize";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/dockerize" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "dockerize";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
