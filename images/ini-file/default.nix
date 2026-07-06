{ mkImage, pkgs, lib, ... }:

# ini-file - small CLI for editing INI-format config files
# https://github.com/bitnami/ini-file
#
# Prior revision consumed the upstream prebuilt Linux tarball, which is
# Go-stdlib v1.25.0 stale (crit CVEs). Rebuild from source with current
# nixpkgs Go so stdlib patches forward at each build.

let
  version = "1.4.9";

  drv = pkgs.buildGoModule {
    pname = "ini-file";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "bitnami";
      repo = "ini-file";
      rev = "v${version}";
      hash = "sha256-XTKi37Z8CF678q34c830DLyfB4rCSJXErsLHHCtZnXM=";
    };

    # Upstream vendor/modules.txt drifts from go.mod; use proxyVendor.
    proxyVendor = true;
    vendorHash = "sha256-t1cByPucjP299l/IV/olZIRCOOG2tYuUgnhvQAalIwQ=";

    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    env.GOTOOLCHAIN = "local";
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "ini-file";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/ini-file" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "ini-file";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
