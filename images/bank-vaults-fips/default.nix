{ mkImage, pkgs, lib, ... }:

# bank-vaults - CLI for HashiCorp Vault automation
# https://github.com/bank-vaults/bank-vaults
# -fips variant packages the upstream bank-vaults binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.
let
  version = "1.33.1";

  drv = pkgs.buildGoModule {
    pname = "bank-vaults";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "bank-vaults";
      repo = "bank-vaults";
      rev = "v${version}";
      hash = "sha256-D0rgrYQDIYU6BwSOgmDLbetDsyCT6Dvlw0UminH4hfo=";
    };

    proxyVendor = true;
    vendorHash = "sha256-WgsaZoTmBkIq7YbX3B3WMwd5+lhMIOUM4N8cYPj2hqA=";

    subPackages = [ "cmd/bank-vaults" ];
    ldflags = [ "-s" "-w" ];
    # bank-vaults imports miekg/pkcs11/p11 which requires cgo
    env.CGO_ENABLED = 1;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "bank-vaults-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/bank-vaults" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "bank-vaults";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
