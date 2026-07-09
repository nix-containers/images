{ mkImage, pkgs, lib, ... }:

# Omni - Sidero Labs Kubernetes/Talos management platform (-fips variant)
# https://github.com/siderolabs/omni
# -fips variant packages the upstream binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild. Aligned to v1.9.1 to
# match the sibling `omni` image (previously drifted to 1.9.0).

let
  version = "1.9.1";

  drv = pkgs.buildGoModule {
    pname = "omni-fips";
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
  };
in mkImage {
  inherit drv;
  name = "omni-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/omni" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "omni-fips";
    "org.opencontainers.image.description" = "Sidero Labs Omni management platform";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
