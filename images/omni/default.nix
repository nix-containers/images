{ mkImage, pkgs, lib, ... }:

# Omni - Sidero Omni: manage Kubernetes clusters across bare metal, VMs, and cloud
# https://github.com/siderolabs/omni
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "1.9.1";

  drv = pkgs.buildGoModule {
    pname = "omni";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "siderolabs";
      repo = "omni";
      rev = "v${version}";
      hash = "sha256-k2z0QBkMJkLFtrr9ckWyS1a4jzGYkikREf8+aaMW3d0=";
    };

    proxyVendor = true;
    vendorHash = "sha256-1IcWXcAn2kmxI4ux4J1hfNZWfQfvNS0+28e+iXPz0Uw=";

    subPackages = [ "cmd/omni" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    meta = with lib; {
      description = "Sidero Omni - manage Kubernetes clusters across bare metal, VMs, and cloud";
      homepage = "https://github.com/siderolabs/omni";
      license = licenses.bsl11;
      platforms = [ "x86_64-linux" ];
    };
  };

in mkImage {
  inherit drv;
  name = "omni";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/omni" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "omni";
    "org.opencontainers.image.description" = "Sidero Omni - Kubernetes management plane";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
