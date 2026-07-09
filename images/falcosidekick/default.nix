{ mkImage, pkgs, lib, ... }:

# Falcosidekick - connect Falco to your ecosystem
# https://github.com/falcosecurity/falcosidekick
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "2.34.1";

  drv = pkgs.buildGoModule {
    pname = "falcosidekick";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "falcosecurity";
      repo = "falcosidekick";
      rev = version;
      hash = "sha256-EliSHEYJsgF3BroTIvBh6dL8Eec3F7Bf4PykGqSKa1Q=";
    };

    proxyVendor = true;
    vendorHash = "sha256-i8Hj3zbpKt1btvaNEALz31XV4ki/359IxwGM7bQovv0=";

    subPackages = [ "." ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    meta = with lib; {
      description = "Connect Falco to your ecosystem";
      homepage = "https://github.com/falcosecurity/falcosidekick";
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
    };
  };

in mkImage {
  inherit drv;
  name = "falcosidekick";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/falcosidekick" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "falcosidekick";
    "org.opencontainers.image.description" = "Connect Falco to your ecosystem";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
