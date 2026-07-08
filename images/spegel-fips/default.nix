{ mkImage, pkgs, lib, ... }:

# Spegel - stateless cluster local OCI registry mirror
# https://github.com/spegel-org/spegel
# -fips variant packages the upstream spegel binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "0.7.2";

  drv = pkgs.buildGoModule {
    pname = "spegel";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "spegel-org";
      repo = "spegel";
      rev = "v${version}";
      hash = "sha256-6U1DF6gy0L0m8tBcWQGPbIAEkiSSWBagYHgjPWfh9XQ=";
    };

    proxyVendor = true;
    vendorHash = "sha256-Brc5jR/2VYe07zmC/WUKBdtgz1AICvt7ORiCUN3Pfjg=";

    subPackages = [ "." ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "spegel-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/spegel" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "spegel-fips";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
