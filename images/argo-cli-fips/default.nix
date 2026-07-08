{ mkImage, pkgs, lib, ... }:

# Argo Workflows CLI (argo-cli-fips variant)
# https://github.com/argoproj/argo-workflows
# -fips variant packages the upstream argo binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "4.0.6";

  drv = pkgs.buildGoModule {
    pname = "argo";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "argoproj";
      repo = "argo-workflows";
      rev = "v${version}";
      hash = "sha256-3UTvyOI3T7BvQAPi1Zl+DhUw7Y+TiBVT50Y2CL5eEm0=";
    };

    proxyVendor = true;
    vendorHash = "sha256-dbBer2RhUWcc+o/HdSy9xrsuQ9vJhL/7sUuwpnHcMz8=";

    subPackages = [ "cmd/argo" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    # ui/embed.go embeds ui/dist/app which is produced by the JS UI build.
    # The CLI doesn't need it, but the embed directive requires the dir exist.
    # Create a stub so the module compiles.
    preBuild = ''
      mkdir -p ui/dist/app
      touch ui/dist/app/index.html
    '';
  };
in mkImage {
  inherit drv;
  name = "argo-cli-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/argo" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "argo-cli-fips";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
